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
    
    private var titleLabelLeadingConstraint: NSLayoutConstraint?
    private var moreButtonTrailingConstraint: NSLayoutConstraint?
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 26)
        lb.textColor = .black
        lb.text = "상영중인 영화"
        return lb
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        titleLabelLeadingConstraint?.isActive = true
        
        addSubview(moreButton)
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            moreButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        moreButtonTrailingConstraint = moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        moreButtonTrailingConstraint?.isActive = true
    }
    
    func configure(title: String) {
        titleLabel.text = title
        
        if title == "상영예정인 영화" {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabelLeadingConstraint?.isActive = false
            moreButtonTrailingConstraint?.isActive = false
            titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)
            moreButtonTrailingConstraint = moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
            titleLabelLeadingConstraint?.isActive = true
            moreButtonTrailingConstraint?.isActive = true
        }
    }
}

