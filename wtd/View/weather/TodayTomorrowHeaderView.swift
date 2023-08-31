//
//  TodayTomorrowHeaderView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/31.
//

import UIKit

class TodayTomorrowHeaderView: UIView {
    //MARK: - properties ==================
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .myDarkGray
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    //MARK: - lifecycle ==================
    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - func ==================
extension TodayTomorrowHeaderView {
    private func setLayout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
