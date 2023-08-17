//
//  ReservationButtonView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/11.
//

import UIKit

class ReservationButtonView: UIView {
    //MARK: - properties ==================
    var appId: String
    var appUrl: String
    
    private let containerView: ShadowView = {
        let v = ShadowView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        v.backgroundColor = .myWhite
        v.layer.masksToBounds = false
        return v
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(tapMovieApp), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - lifecycle ==================
    init(imageName: String, url: String, id: String) {
        self.appId = id
        self.appUrl = url
        super.init(frame: .zero)
        setLayout()
        imageView.image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReservationButtonView {
    private func setLayout() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 35),
            imageView.widthAnchor.constraint(equalToConstant: 35),
        ])
        
        containerView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            button.topAnchor.constraint(equalTo: containerView.topAnchor),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    @objc func tapMovieApp() {
        CommonUtil.moveAnotherApp(url: appUrl, appId: appId)
    }
}
