//
//  LaunchVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/28.
//

import UIKit

class LaunchVC: UIViewController {
    //MARK: - properties ==================
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .myBlack
        lb.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 30)
        lb.text = "왓투두"
        return lb
    }()
    private let logoImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
}

extension LaunchVC {
    private func setLayout() {
        view.backgroundColor = .white
        
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 150),
            logoImage.heightAnchor.constraint(equalToConstant: 150),
        ])
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: logoImage.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor)
        ])
    }
}
