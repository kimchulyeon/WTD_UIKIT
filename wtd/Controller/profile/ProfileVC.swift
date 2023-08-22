//
//  ProfileVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class ProfileVC: UIViewController {
    //MARK: - properties ==================
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "Haddi")
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    private let nicknameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = UserDefaultsManager.shared.getUserDefaultData(field: .Name)
        lb.textColor = .myDarkGray
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    private lazy var editNicknameButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "pencil")?.withTintColor(.primary), for: .normal)
        btn.addTarget(self, action: #selector(handleEditNickname), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonUtil.configureNavBar(for: self)
        CommonUtil.configureBasicView(for: self)
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("PROFILE VC VIEW WILL APPEAR")
    }
}

extension ProfileVC {
    private func setLayout() {
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        view.addSubview(nicknameLabel)
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            nicknameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 15)
        ])
        
        view.addSubview(editNicknameButton)
        NSLayoutConstraint.activate([
            editNicknameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editNicknameButton.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 2),
            editNicknameButton.widthAnchor.constraint(equalToConstant: 13),
            editNicknameButton.heightAnchor.constraint(equalToConstant: 13),
        ])
    }
    
    @objc func handleEditNickname() {
        print("닉네임 변경하기")
    }
}
