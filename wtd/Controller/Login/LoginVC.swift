//
//  LoginVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/04.
//

import UIKit
import AuthenticationServices

class LoginVC: UIViewController {
	//MARK: - Properties
	let vm = LoginViewModel()

	private let bigTitle: UILabel = {
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
		lb.text = "습관처럼 꺼내는 앱\n왓투두에서 편리하게"
		lb.textColor = UIColor.myBlack
		lb.numberOfLines = 2
		lb.textAlignment = .left
		lb.font = UIFont.boldSystemFont(ofSize: 32)
		return lb
	}()

	private let smallTitle: UILabel = {
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
		lb.numberOfLines = 3
		lb.textAlignment = .left
		lb.font = UIFont.systemFont(ofSize: 16)
		let text = "오늘 날씨는 어떤지\n주변에 뭐가 있나\n요즘 볼만한 영화는 뭐가 있는지"
		let attributtedString = NSMutableAttributedString(string: text)
		let w_range = (text as NSString).range(of: "날씨")
		let p_range = (text as NSString).range(of: "주변")
		let m_range = (text as NSString).range(of: "영화")
		let color = UIColor.primary
		attributtedString.addAttribute(.foregroundColor, value: color, range: w_range)
		attributtedString.addAttribute(.foregroundColor, value: color, range: p_range)
		attributtedString.addAttribute(.foregroundColor, value: color, range: m_range)
		lb.attributedText = attributtedString
		return lb
	}()

	private let googleButton: GoogleButton = {
		let btn = GoogleButton(frame: .zero)
		btn.translatesAutoresizingMaskIntoConstraints = false
		return btn
	}()

	private let appleButton: ASAuthorizationAppleIDButton = {
		let btn = ASAuthorizationAppleIDButton()
		btn.translatesAutoresizingMaskIntoConstraints = false
		return btn
	}()


	//MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()

        print("로그인 :::::::🚀")
		setView()
		setButtonEvent()
	}

	//MARK: - FUNC ==================
	/// 로그인 뷰 세팅
	private func setView() {
		view.addSubview(bigTitle)
		NSLayoutConstraint.activate([
			bigTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
			bigTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15)
		])

		view.addSubview(smallTitle)
		NSLayoutConstraint.activate([
			smallTitle.topAnchor.constraint(equalTo: bigTitle.bottomAnchor, constant: 30),
			smallTitle.leadingAnchor.constraint(equalTo: bigTitle.leadingAnchor)
		])

		view.addSubview(googleButton)
		NSLayoutConstraint.activate([
			googleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
			googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			googleButton.leadingAnchor.constraint(equalTo: bigTitle.leadingAnchor),
			googleButton.heightAnchor.constraint(equalToConstant: 60)
		])

		view.addSubview(appleButton)
		NSLayoutConstraint.activate([
			appleButton.bottomAnchor.constraint(equalTo: googleButton.topAnchor, constant: -10),
			appleButton.leadingAnchor.constraint(equalTo: bigTitle.leadingAnchor),
			appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			appleButton.heightAnchor.constraint(equalToConstant: 60)
		])
	}

	/// 로그인 버튼 세팅
	private func setButtonEvent() {
		appleButton.addTarget(self, action: #selector(tapAppleButton), for: .touchUpInside)
		googleButton.addTarget(self, action: #selector(tapGoogleButton), for: .touchUpInside)
	}
	@objc func tapAppleButton() {
		vm.handleAppleLogin(with: self)
	}
	@objc func tapGoogleButton() {
		vm.handleGoogleLogin(with: self)
	}
}

