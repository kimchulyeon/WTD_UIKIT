//
//  loginViewModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/05.
//

import UIKit

class LoginViewModel: NSObject {
	/// 애플 로그인
	func handleAppleLogin(with vc: LoginVC) {
		AppleService.shared.startSignInWithAppleFlow(view: vc)
	}

	/// 구글 로그인
	func handleGoogleLogin(with vc: LoginVC) {
		GoogleService.shared.startSignInWithGoogleFlow(with: vc)
	}
}
