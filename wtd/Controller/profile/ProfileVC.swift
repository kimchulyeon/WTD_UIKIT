//
//  ProfileVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit
import PhotosUI

class ProfileVC: UIViewController {
    //MARK: - properties ==================
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "Haddi")
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    private lazy var editImageButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "photo.circle"), for: .normal)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(tapImageEditButton), for: .touchUpInside)
        btn.isHidden = UserDefaultsManager.shared.isGuest()
        return btn
    }()
    private let nicknameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .myDarkGray
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    private lazy var editNicknameButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("닉네임 변경", for: .normal)
        btn.backgroundColor = .primary
        btn.tintColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(tapEditNickname), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        btn.isHidden = UserDefaultsManager.shared.isGuest()
        return btn
    }()
    private lazy var imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.sourceType = .photoLibrary
        ip.delegate = self
        ip.allowsEditing = true
        return ip
    }()
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        CommonUtil.configureNavBar(for: self)
        CommonUtil.configureBasicView(for: self)
        setLayout()
        setNickname()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("PROFILE VC VIEW WILL APPEAR")
    }

    deinit {
        print("PROFILE VC DEINIT ❌❌❌❌❌❌❌❌❌❌❌❌")
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - func ==================
extension ProfileVC {
    private func setLayout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        containerView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
        ])

        containerView.addSubview(editImageButton)
        NSLayoutConstraint.activate([
            editImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -8),
            editImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -8),
            editImageButton.widthAnchor.constraint(equalToConstant: 20),
            editImageButton.heightAnchor.constraint(equalToConstant: 20),
        ])

        containerView.addSubview(nicknameLabel)
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            nicknameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nicknameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: 15)
        ])

        containerView.addSubview(editNicknameButton)
        NSLayoutConstraint.activate([
            editNicknameButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            editNicknameButton.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            editNicknameButton.widthAnchor.constraint(equalToConstant: 100),
            editNicknameButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        let licenseButton = ProfileButtonView(title: ProfileButtonTitle.license, accessoryImage: UIImage(systemName: "chevron.right")!)
        let supportButton = ProfileButtonView(title: ProfileButtonTitle.support, accessoryImage: nil)
        let logoutButton = ProfileButtonView(title: ProfileButtonTitle.logout, accessoryImage: nil)
        let leaveButton = ProfileButtonView(title: ProfileButtonTitle.leave, accessoryImage: nil)
        let loginButton = ProfileButtonView(title: ProfileButtonTitle.login, accessoryImage: nil)

        logoutButton.isHidden = UserDefaultsManager.shared.isGuest()
        leaveButton.isHidden = UserDefaultsManager.shared.isGuest()
        loginButton.isHidden = UserDefaultsManager.shared.isGuest() == false
        licenseButton.delegate = self
        supportButton.delegate = self
        logoutButton.delegate = self
        leaveButton.delegate = self
        loginButton.delegate = self
        buttonStackView.addArrangedSubview(licenseButton)
        buttonStackView.addArrangedSubview(supportButton)
        buttonStackView.addArrangedSubview(logoutButton)
        buttonStackView.addArrangedSubview(leaveButton)
        buttonStackView.addArrangedSubview(loginButton)

        scrollView.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: editNicknameButton.bottomAnchor, constant: 20),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }

    /// 닉네임 구성
    private func setNickname() {
        let storedNickname = UserDefaultsManager.shared.getUserDefaultData(field: .Name)
        if storedNickname == "" {
            nicknameLabel.text = "Guest"
        } else {
            nicknameLabel.text = storedNickname
        }
    }

    /// 닉네임 변경 탭
    @objc func tapEditNickname() {
        let alertController = UIAlertController(title: "닉네임 변경", message: "8자 이하로 입력해주세요", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = UserDefaultsManager.shared.getUserDefaultData(field: .Name)
        }

        let editAction = UIAlertAction(title: "변경", style: .default) { [weak self] action in
            if let textField = alertController.textFields?.first, let input = textField.text {
                if input.count < 1 || input.count > 8 {
                    return
                } else {
                    self?.changeNickname(nickname: input)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    /// 닉네임 변경 핸들러
    private func changeNickname(nickname: String) {
        guard let docID = UserDefaultsManager.shared.getUserDefaultData(field: .DocID) else { return }
        FirebaseService.shared.changeNicknameInDatabase(with: docID, newValue: nickname) { success in
            if success {
                UserDefaults.standard.set(nickname, forKey: FirestoreFieldConstant.Name.rawValue)
                DispatchQueue.main.async { [weak self] in
                    self?.nicknameLabel.text = UserDefaultsManager.shared.getUserDefaultData(field: .Name)
                    self?.view.layoutIfNeeded()
                }
            } else {
                print("Error while changing nickname at \(#file) :::::::❌")
            }
        }
    }

    /// 이미지 편집 버튼 탭
    @objc func tapImageEditButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "카메라", style: .default, handler: { [weak self] _ in
            guard let weakSelf = self else { return }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                weakSelf.imagePicker.sourceType = .camera
                weakSelf.present(weakSelf.imagePicker, animated: true)
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "사진첩", style: .default, handler: { [weak self] _ in
            guard let weakSelf = self else { return }
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            weakSelf.present(picker, animated: true)
        }))

        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate ==================
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.profileImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - ProfileButtonViewDelegate ==================
extension ProfileVC: ProfileButtonViewDelegate {
    func tapLicense(title: ProfileButtonTitle) {
        let privacyVC = WebVC()
        privacyVC.urlString = "https://carbonated-stoplight-4f5.notion.site/License-7e084b62120e4642915070d096574d8f?pvs=4"
        navigationController?.pushViewController(privacyVC, animated: true)
    }

    func tapSupport(title: ProfileButtonTitle) {
        CommonUtil.showAlert(title: "문의하기", message: "이메일 : guinness987@gmail.com", actionTitle: "이메일 복사하기", actionStyle: .default) { _ in
            UIPasteboard.general.string = "guinness987@gmail.com"
            return
        } cancelHandler: { _ in
            return
        }
    }

    func tapLogout(title: ProfileButtonTitle) {
        CommonUtil.showAlert(title: "로그아웃을 하시겠습니까?", message: nil, actionTitle: "확인", actionStyle: .destructive) { _ in
            FirebaseService.shared.signout() {
                UserDefaultsManager.shared.resetUserDefaults() {
                    CommonUtil.changeRootView(to: LoginVC())
                }
            }
        } cancelHandler: { _ in
            return
        }
    }

    func tapLeave(title: ProfileButtonTitle) {
        CommonUtil.showAlert(title: "정말 탈퇴하시겠습니까?", message: nil, actionTitle: "확인", actionStyle: .destructive) { _ in
            FirebaseService.shared.leave() {
                UserDefaultsManager.shared.resetUserDefaults() {
                    CommonUtil.changeRootView(to: LoginVC())
                }
            }
        } cancelHandler: { _ in
            return
        }
    }
    func tapLogin(title: ProfileButtonTitle) {
        CommonUtil.changeRootView(to: LoginVC())
    }
}
