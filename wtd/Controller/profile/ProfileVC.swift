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
    private lazy var editImageButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "photo.circle"), for: .normal)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
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
        btn.addTarget(self, action: #selector(handleEditNickname), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        return btn
    }()
    private lazy var imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.sourceType = .photoLibrary
        ip.delegate = self
        ip.allowsEditing = true
        return ip
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        CommonUtil.configureNavBar(for: self)
        CommonUtil.configureBasicView(for: self)
        setLayout()
        setNickname()

        print(UserDefaultsManager.shared.getUserDefaultData(field: .Name) == "")
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

        view.addSubview(editImageButton)
        NSLayoutConstraint.activate([
            editImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -8),
            editImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -8),
            editImageButton.widthAnchor.constraint(equalToConstant: 20),
            editImageButton.heightAnchor.constraint(equalToConstant: 20),
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
            editNicknameButton.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            editNicknameButton.widthAnchor.constraint(equalToConstant: 100),
            editNicknameButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    private func setNickname() {
        let storedNickname = UserDefaultsManager.shared.getUserDefaultData(field: .Name)
        if storedNickname == "" {
            nicknameLabel.text = "Unknown"
        } else {
            nicknameLabel.text = storedNickname
        }
    }

    @objc func handleEditNickname() {
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

    private func changeNickname(nickname: String) {
        let docID = UserDefaultsManager.shared.getUserDefaultData(field: .DocID)
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

    @objc func showImagePicker() {
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
            weakSelf.imagePicker.sourceType = .photoLibrary
            weakSelf.present(weakSelf.imagePicker, animated: true)
        }))

        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
}

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
