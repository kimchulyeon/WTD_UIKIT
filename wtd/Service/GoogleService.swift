//
//  GoogleService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/05.
//

import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

final class GoogleService {
    //MARK: - properties ==================
    static let shared = GoogleService()
    private init() { }
}

//MARK: - func ==================
extension GoogleService {
    /// 구글 로그인 실행
    func startSignInWithGoogleFlow(with view: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { result, error in
            if let error = error {
                print("Error while signing in google with \(error) :::::::❌")
                return
            } else {
                guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                    print("Error There is no user or idToken while google sign in :::::::: ❌")
                    return
                }

                let name = result?.user.profile?.name ?? ""
                let email = result?.user.profile?.email ?? ""
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                let provider = ProviderType.google.rawValue

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
