//
//  NowSectionHeader.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/04.
//

import UIKit

class NowSectionHeader: UICollectionReusableView {
    //MARK: - properties ==================
    static let identifier = "NowSectionHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    private let moreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("더보기", for: .normal)
        return btn
    }()
    
    //MARK: - lifecycle ==================
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NowSectionHeader {
    private func configure() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(moreButton)
        NSLayoutConstraint.activate([
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moreButton.topAnchor.constraint(equalTo: topAnchor),
            moreButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

