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

				let credential = GoogleAuthProvider.credential(withIDToken: idToken,
				                                               accessToken: user.accessToken.tokenString)

				// 유저를 파이어베이스 가입시키고
				// 유저 정보를 파이어베이스 데이터베이스 저장
				// UserDefaults에 로그인하면 유저 정보 저장
				// 로그인하기해서 신규 유저인지 아닌지 판단해서 저장하는 로직 태우냐 마냐
				Auth.auth().signIn(with: credential) { result, error in
					if let error = error {
						print("Error \(error.localizedDescription) :::::::: ❌")
					} else {
						print("USER ID : \(user.userID ?? "-")")
						print("EMAIL : \(result?.user.email ?? "-")")
						print("FULL NAME: \(result?.user.displayName ?? "-")")
						print("UID : \(result?.user.uid ?? "-")")
					}
				}
			}
		}
	}
}
