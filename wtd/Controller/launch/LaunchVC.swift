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
        lb.textColor = .myWhite
        lb.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 50)
        lb.text = "왓투두"
        return lb
    }()
    
    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
}

extension LaunchVC {
    private func setLayout() {
        view.backgroundColor = .secondary
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90)
        ])
    }
}
