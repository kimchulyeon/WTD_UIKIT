//
//  AppleService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/05.
// https://firebase.google.com/docs/auth/ios/apple?hl=ko&authuser=0&_gl=1*s6425a*_ga*MTMxMTIxNjg5OC4xNjc4Njc5MTY5*_ga_CW55HF8NVT*MTY4ODUzMjAwNi4zNC4xLjE2ODg1MzIyODAuMC4wLjA.

import Foundation
import CryptoKit
import FirebaseAuth
import AuthenticationServices

class AppleService: NSObject, ASAuthorizationControllerDelegate {
    static let shared = AppleService()
    private override init() { }
    var loginView: LoginVC!
    var locationManager: LocationManager?

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }



    // Unhashed nonce.
    fileprivate var currentNonce: String?


    /// 애플 로그인 플로우
    @available(iOS 13, *) func startSignInWithAppleFlow(view: LoginVC) {
        self.loginView = view

        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

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
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)


            // 유저를 파이어베이스 가입시키고
            // 로그인하기해서 신규 유저인지 아닌지 판단해서 저장하는 로직 태우냐 마냐
            // 유저 정보를 파이어베이스 데이터베이스 저장
            // UserDefaults에 로그인하면 유저 정보 저장
            FirebaseService.shared.loginFirebase(credential: credential) { uid, isNewUser, docID in
                if let uid = uid {
                    print("UID : \(uid)")
                    print("EMAIL : \(email)")
                    print("NAME : \(name)")

                    
                    if isNewUser {
                        FirebaseService.shared.saveUserInDatabase(name: name, email: email, uid: uid) {docID in
                            print("DATABASE에 저장 완료 🟢")

                            UserDefaultsService.shared.saveUserInfo(name: name, email: email, docID: docID, uid: uid) { [weak self] in
                                
                                self?.locationManager = LocationManager()
                                CommonUtil.changeRootView(to: BaseTabBar())
                            }
                        }
                    } else {
                        // docID로 유저 정보 가져오기
                        guard let docID = docID else { return }
                        FirebaseService.shared.getUserInfo(with: docID) { name, email, uid, docID in
                            print("가입되어 있는 유저 NAME : \(name)")
                            print("가입되어 있는 유저 EMAIL : \(email)")
                            print("가입되어 있는 유저 UID : \(uid)")
                            print("가입되어 있는 유저 DOC ID : \(docID)")
                            
                            UserDefaultsService.shared.saveUserInfo(name: name, email: email, docID: docID, uid: uid) { [weak self] in
                                
                                self?.locationManager = LocationManager()
                                CommonUtil.changeRootView(to: BaseTabBar())
                            }
                        }
                    }
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

    func formatName(credentialName: PersonNameComponents?) -> String {
        if let fullName = credentialName {
            let formatter = PersonNameComponentsFormatter()
            return formatter.string(from: fullName)
        }
        return ""
    }
}



