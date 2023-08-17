//
//  NearMeCategoryCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/16.
//

import UIKit

class NearMeCategoryCell: UICollectionViewCell {
    //MARK: - properties ==================
    static let identifier = "NearMeCategoryCell"

    private lazy var containerView: ShadowView = {
        let sv = ShadowView()
        sv.backgroundColor = .myWhite
        return sv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .myBlack
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
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

extension NearMeCategoryCell {
    private func setLayout() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
    
    func configure(text: String) {
        titleLabel.text = text
    }
}
