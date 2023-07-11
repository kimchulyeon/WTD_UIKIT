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

class GoogleService {
    static let shared = GoogleService()

    private init() { }

    var loginView: LoginVC!
    var locationManager: LocationManager?

    func startSignInWithGoogleFlow(with view: LoginVC) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let user = result?.user,
                    let idToken = user.idToken?.tokenString else {

                    print("Error There is no user or idToken while google sign in :::::::: ❌")
                    return
                }

                let name = result?.user.profile?.name ?? "-"
                let email = result?.user.profile?.email ?? "-"
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)

                // 유저를 파이어베이스 가입시키고
                // 로그인하기해서 신규 유저인지 아닌지 판단해서 저장하는 로직 태우냐 마냐
                // 유저 정보를 파이어베이스 데이터베이스 저장
                // UserDefaults에 로그인하면 유저 정보 저장
                FirebaseService.shared.loginFirebase(credential: credential) { uid, isNewUser, docID in
                    if let uid = uid {
                        print("GOOGLE UID : \(uid)")
                        print("GOOGLE NAME : \(name)")
                        print("GOOGLE email : \(email)")


                        if isNewUser {
                            FirebaseService.shared.saveUserInDatabase(name: name, email: email, uid: uid) {docID in 
                                print("DATABASE에 저장 완료 🟢🟢🟢")
                                
                                UserDefaultsManager.shared.saveUserInfo(name: name, email: email, docID: docID, uid: uid) { [weak self] in
                                    
                                    self?.locationManager = LocationManager()
                                    CommonUtil.changeRootView(to: BaseTabBar())
                                }
                            }
                        } else {
                            guard let docID = docID else { return }
                            FirebaseService.shared.getUserInfo(with: docID) { name, email, uid, docID in
                                print("GOOGLE 가입되어 있는 유저 NAME : \(name)")
                                print("GOOGLE 가입되어 있는 유저 EMAIL : \(email)")
                                print("GOOGLE 가입되어 있는 유저 UID : \(uid)")
                                print("GOOGLE 가입되어 있는 유저 DOC ID : \(docID)")
                                
                                UserDefaultsManager.shared.saveUserInfo(name: name, email: email, docID: docID, uid: uid) { [weak self] in
                                    
                                    self?.locationManager = LocationManager()
                                    CommonUtil.changeRootView(to: BaseTabBar())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
