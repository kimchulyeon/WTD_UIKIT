//
//  GoogleButton.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/05.
//

import UIKit

class GoogleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 6
        self.backgroundColor = UIColor.googleButton

        if let originalImage = UIImage(named: "google"),
           let resizedImage = originalImage.resized(to: CGSize(width: 16, height: 16)) {
            self.setImage(resizedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        self.tintColor = .white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        self.setTitleColor(.white, for: .normal)
        self.setTitle("Sign in with Google", for: .normal)
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

