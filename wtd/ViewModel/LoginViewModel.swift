//
//  loginViewModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/05.
//

import UIKit

final class LoginViewModel: NSObject {
    //MARK: - properties ==================
    var isAgreed = false
    
    //MARK: - func ==================
	/// 애플 로그인
	func handleAppleLogin(with vc: LoginVC) {
        if isAgreed == true {
            AppleService.shared.startSignInWithAppleFlow(view: vc)
        } else {
            showTermsAgreeAlert()
        }
	}

	/// 구글 로그인
	func handleGoogleLogin(with vc: LoginVC) {
        if isAgreed == true {
            GoogleService.shared.startSignInWithGoogleFlow(with: vc)
        } else {
            showTermsAgreeAlert()
        }
	}
    
    /// 게스트 로그인
    func handleGuestLogin(with vc: LoginVC) {
        if isAgreed == true {
            CommonUtil.changeRootView(to: BaseTabBar())
        } else {
            CommonUtil.showAlert(title: "이용 약관을 동의해주세요", message: nil, actionTitle: "확인", actionStyle: .default) { _ in return }
        }
    }
    
    /// 약관 동의 변경
    func toggleIsAgreed() {
        isAgreed.toggle()
    }
    
    /// 약관 동의 리셋
    func resetIsAgreed() {
        isAgreed = false
    }
    
    /// 약관 동의 알럿
    private func showTermsAgreeAlert() {
        CommonUtil.showAlert(title: "이용 약관을 동의해주세요", message: nil, actionTitle: "확인", actionStyle: .default) { _ in return }
    }
}
