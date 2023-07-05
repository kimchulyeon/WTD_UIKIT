//
//  loginViewModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/05.
//

import UIKit

class LoginViewModel {
    func handleAppleLogin(with vc: LoginVC) {
        AppleService.shared.startSignInWithAppleFlow(view: vc)
    }
}
