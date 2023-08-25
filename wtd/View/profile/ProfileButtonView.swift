//
//  ProfileButtonView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/25.
//

import UIKit

protocol ProfileButtonViewDelegate: AnyObject {
    func tapLicense(title: ProfileButtonTitle)
    func tapSupport(title: ProfileButtonTitle)
    func tapLogout(title: ProfileButtonTitle)
    func tapLeave(title: ProfileButtonTitle)
    func tapLogin(title: ProfileButtonTitle)
}

class ProfileButtonView: UIView {
    //MARK: - properties ==================
    weak var delegate: ProfileButtonViewDelegate?
    var buttonTitle: ProfileButtonTitle?
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.isUserInteractionEnabled = true
        return sv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .myDarkGray
        lb.font = UIFont.systemFont(ofSize: 24)
        return lb
    }()
    private let accessoryView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .myDarkGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    //MARK: - lifecycle ==================
    init(title: ProfileButtonTitle, accessoryImage: UIImage?) {
        super.init(frame: .zero)
        buttonTitle = title
        setLayout()
        configTitleLabel(title: title.rawValue)
        accessoryView.image = accessoryImage
        addTapGestureDependingOn(title: title)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - function ==================
extension ProfileButtonView {
    private func setLayout() {
        addSubview(containerView)
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(accessoryView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
    
    /// 버튼 타이틀 구성
    private func configTitleLabel(title: String) {
        if title.contains("탈퇴") {
            titleLabel.textColor = .systemRed
        }
        titleLabel.text = title
    }
    
    /// 버튼 타이틀에 따라 탭 제스쳐 구성
    private func addTapGestureDependingOn(title: ProfileButtonTitle) {
        var tapGesture: UITapGestureRecognizer
        switch title {
        case .license:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLicense))
        case .support:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSupport))
        case .logout:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLogout))
        case .leave:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLeave))
        case .login:
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLogin))
        }
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapLicense() {
        guard let title = buttonTitle else { return }
        delegate?.tapLicense(title: title)
    }
    @objc func tapSupport() {
        guard let title = buttonTitle else { return }
        delegate?.tapSupport(title: title)
    }
    @objc func tapLogout() {
        guard let title = buttonTitle else { return }
        delegate?.tapLogout(title: title)
    }
    @objc func tapLeave() {
        guard let title = buttonTitle else { return }
        delegate?.tapLeave(title: title)
    }
    @objc func tapLogin() {
        guard let title = buttonTitle else { return }
        delegate?.tapLogin(title: title)
    }
}
