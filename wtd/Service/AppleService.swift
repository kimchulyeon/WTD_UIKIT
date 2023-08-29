//
//  AppleService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/05.
//

import Foundation
import CryptoKit
import FirebaseAuth
import AuthenticationServices

final class AppleService: NSObject {
    //MARK: - properties ==================
    static let shared = AppleService()
    private override init() { }
    var initLoginFlowViewController: UIViewController!
    fileprivate var currentNonce: String?
}

//MARK: - func ==================
extension AppleService {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in charset[Int(byte) % charset.count] }
        return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }

    /// 애플 로그인 플로우
    @available(iOS 13, *) func startSignInWithAppleFlow(view: UIViewController) {
        let nonce = randomNonceString()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        initLoginFlowViewController = view
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func formatName(credentialName: PersonNameComponents?) -> String {
        guard let fullName = credentialName else { return "" }
        let formatter = PersonNameComponentsFormatter()
        return formatter.string(from: fullName)
    }
    
    /// 신규회원일 경우 파이어스토어에 유저정보 저장
    private func saveUserDatasAtFireStore(name: String, email: String, uid: String, provider: String) {
        FirebaseService.shared.saveUserInDatabase(name: name, email: email, uid: uid, provider: provider) { docID in
            UserDefaultsManager.shared.saveUserInfo(name: name, email: email, docID: docID, uid: uid, provider: provider) {
                CommonUtil.changeRootView(to: BaseTabBar())
            }
        }
    }

    /// 기존회원일 경우 UserDefaults에 유저정보 저장
    private func saveUserDatasAtUserDefaults(name: String, email: String, uid: String, provider: String, docID: String) {
        FirebaseService.shared.getUserInfo(with: docID) { name, email, uid, docID, provider in
            UserDefaultsManager.shared.saveUserInfo(name: name, email: email, docID: docID, uid: uid, provider: provider) {
                CommonUtil.changeRootView(to: BaseTabBar())
            }
        }
    }
}

//MARK: - ASAuthorizationControllerDelegate ==================
extension AppleService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let email = appleIDCredential.email ?? ""
            let name = formatName(credentialName: appleIDCredential.fullName)
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            let provider = ProviderType.apple.rawValue

            // credential로 파이어베이스 로그인
            FirebaseService.shared.loginFirebase(credential: credential) { [weak self] uid, isNewUser, docID in
                guard let weakSelf = self, let uid = uid else { return }
                if isNewUser {
                    weakSelf.saveUserDatasAtFireStore(name: name, email: email, uid: uid, provider: provider)
                } else {
                    guard let weakSelf = self, let docID = docID else { return }
                    weakSelf.saveUserDatasAtUserDefaults(name: name, email: email, uid: uid, provider: provider, docID: docID)
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error Sign in with Apple errored: \(error) ❌")
    }
}

//MARK: - ASAuthorizationControllerPresentationContextProviding ==================
extension AppleService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = initLoginFlowViewController.view.window else { fatalError("No Window") }
        return window
    }
}


