//
//  RequestLocationView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/14.
//

import Foundation

import UIKit

class RequestLocationView: UIView {
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        sv.distribution = .fill
        sv.alignment = .center
        return sv
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "location_permission")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "위치 정보 허용"
        lb.font = UIFont.boldSystemFont(ofSize: 26)
        lb.numberOfLines = 1
        return lb
    }()
    private let contentLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "위치 정보를 허용해야\n날씨 데이터를 제공받을 수 있습니다"
        lb.numberOfLines = 2
        lb.textAlignment = .center
        lb.textColor = UIColor.darkGray
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("설정으로 이동", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = UIColor.primary
        btn.tintColor = .white
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(openSetting), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - FUNC ==================
    private func setLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(button)

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            button.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func openSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

