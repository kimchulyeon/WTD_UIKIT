//
//  SectionHeader.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/04.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    //MARK: - properties ==================
    static let identifier = "SectionHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .black
        label.text = "상영중인 영화"
        return label
    }()
    private let moreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.primary, for: .normal)
        btn.setTitle("더보기", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    //MARK: - lifecycle ==================
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionHeader {
    private func setLayout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(moreButton)
        NSLayoutConstraint.activate([
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            moreButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            moreButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

