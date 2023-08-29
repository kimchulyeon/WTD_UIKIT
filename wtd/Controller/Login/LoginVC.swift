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
    let vm = LoginViewModel() // 🌈🌈🌈 TODO 🌈🌈🌈
    var isAgreed = false

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

    private let termsContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()

    private lazy var termsAgreeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = UIColor.myBlack.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(tapTermsAgreeButton), for: .touchUpInside)
        return btn
    }()

    private let termsLabel: UILabel = {
        let lb = UILabel()
        let attributedString = NSMutableAttributedString()
        let underlineString = NSAttributedString(string: "이용 약관 동의", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.primary])
        let nonUnderlineString = NSAttributedString(string: " (필수)", attributes: [.foregroundColor: UIColor.primary])
        attributedString.append(underlineString)
        attributedString.append(nonUnderlineString)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.attributedText = attributedString
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        return lb
    }()

    private lazy var guestButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Login as Guest", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = .secondary
        btn.tintColor = .myWhite
        btn.layer.cornerRadius = 6
        btn.addTarget(self, action: #selector(tapGuestLogin(_:)), for: .touchUpInside)
        return btn
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

        setView()
        setButtonEvent()
        addTapTermsLabelGesture()
    }

    deinit {
        isAgreed = false
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

        view.addSubview(guestButton)
        view.addSubview(appleButton)
        view.addSubview(googleButton)
        NSLayoutConstraint.activate([
            guestButton.bottomAnchor.constraint(equalTo: appleButton.topAnchor, constant: -10),
            guestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guestButton.leadingAnchor.constraint(equalTo: bigTitle.leadingAnchor),
            guestButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            appleButton.bottomAnchor.constraint(equalTo: googleButton.topAnchor, constant: -10),
            appleButton.leadingAnchor.constraint(equalTo: bigTitle.leadingAnchor),
            appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            googleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleButton.leadingAnchor.constraint(equalTo: bigTitle.leadingAnchor),
            googleButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        view.addSubview(termsContainerView)
        NSLayoutConstraint.activate([
            termsContainerView.leadingAnchor.constraint(equalTo: bigTitle.leadingAnchor),
            termsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsContainerView.heightAnchor.constraint(equalToConstant: 60),
            termsContainerView.bottomAnchor.constraint(equalTo: guestButton.topAnchor, constant: -10)
        ])

        termsContainerView.addSubview(termsLabel)
        NSLayoutConstraint.activate([
            termsLabel.centerYAnchor.constraint(equalTo: termsContainerView.centerYAnchor),
            termsLabel.centerXAnchor.constraint(equalTo: termsContainerView.centerXAnchor)
        ])

        termsContainerView.addSubview(termsAgreeButton)
        NSLayoutConstraint.activate([
            termsAgreeButton.centerYAnchor.constraint(equalTo: termsContainerView.centerYAnchor),
            termsAgreeButton.leadingAnchor.constraint(equalTo: termsLabel.trailingAnchor, constant: 15),
            termsAgreeButton.heightAnchor.constraint(equalToConstant: 20),
            termsAgreeButton.widthAnchor.constraint(equalToConstant: 20),
        ])
    }

    /// 로그인 버튼 세팅
    private func setButtonEvent() {
        appleButton.addTarget(self, action: #selector(tapAppleButton), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(tapGoogleButton), for: .touchUpInside)
    }
    
    func addTapTermsLabelGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTermsLabel))
        termsLabel.addGestureRecognizer(tapGesture)
        termsLabel.isUserInteractionEnabled = true
    }
    
    /// 애플로그인 탭
    @objc func tapAppleButton() {
        guard isAgreed == true else {
            CommonUtil.showAlert(title: "이용 약관을 동의해주세요", message: nil, actionTitle: "확인", actionStyle: .default) { _ in return }
            return
        }
        vm.handleAppleLogin(with: self)
    }
    
    /// 구글로그인 탭
    @objc func tapGoogleButton() {
        guard isAgreed == true else {
            CommonUtil.showAlert(title: "이용 약관을 동의해주세요", message: nil, actionTitle: "확인", actionStyle: .default) { _ in return }
            return
        }
        vm.handleGoogleLogin(with: self)
    }
    
    /// 게스트 로그인
    @objc func tapGuestLogin(_ sender: UIButton) {
        guard isAgreed == true else {
            CommonUtil.showAlert(title: "이용 약관을 동의해주세요", message: nil, actionTitle: "확인", actionStyle: .default) { _ in return }
            return
        }
        CommonUtil.changeRootView(to: BaseTabBar())
    }
    
    /// 약관 동의 체크박스 탭
    @objc func tapTermsAgreeButton() {
        isAgreed.toggle()

        if isAgreed == true {
            termsAgreeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            termsAgreeButton.setImage(nil, for: .normal)
        }
    }
    
    /// 이용 약관 라벨 탭
    @objc func tapTermsLabel() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let privacyAction = UIAlertAction(title: "개인정보처리방침", style: .default) { [weak self] _ in
            self?.openTermsWebView(with: TermsUrl.privacy)
        }
        let serviceAction = UIAlertAction(title: "서비스 이용약관", style: .default) { [weak self] _ in
            self?.openTermsWebView(with: TermsUrl.service)
        }
        let locationAction = UIAlertAction(title: "위치기반서비스 이용약관", style: .default) { [weak self] _ in
            self?.openTermsWebView(with: TermsUrl.location)
        }
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        actionSheet.addAction(privacyAction)
        actionSheet.addAction(serviceAction)
        actionSheet.addAction(locationAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func openTermsWebView(with url: String) {
        let privacyVC = WebVC()
        privacyVC.modalPresentationStyle = .formSheet
        privacyVC.sheetPresentationController?.prefersGrabberVisible = true
        privacyVC.urlString = url
        present(privacyVC, animated: true)
    }
}

