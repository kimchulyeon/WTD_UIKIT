//
//  ErrorVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/09/04.
//

import UIKit

class ErrorVC: UIViewController {
    //MARK: - properties ==================
    private let errorImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "exclamationmark.triangle.fill")?.resized(to: CGSize(width: 100, height: 100))?.withTintColor(.systemYellow)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "오류가 발생했어요"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textColor = .myBlack
        return lb
    }()
    
    private lazy var retryButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("새로고침", for: .normal)
        btn.backgroundColor = .primary
        btn.tintColor = .myWhite
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(tapRefreshButton), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
}

//MARK: - func ==================
extension ErrorVC {
    private func setLayout() {
        view.backgroundColor = .myWhite
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(errorImage)
        NSLayoutConstraint.activate([
            errorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 20)
        ])
        
        view.addSubview(retryButton)
        NSLayoutConstraint.activate([
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            retryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            retryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            retryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func tapRefreshButton() {
        LocationManager.shared.locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.navigationController?.popViewController(animated: false)
        }
    }
}
