//
//  MovieHeaderView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/28.
//

import UIKit

class MovieHeaderView: UIView {
    //MARK: - properties ==================
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let moreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("더보기", for: .normal)
        btn.setTitleColor(.primary, for: .normal)
        btn.backgroundColor = .clear
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()

    //MARK: - lifecycle ==================
	init(title: String, font: UIFont) {
        super.init(frame: .zero)
		setLayout(title: title, font: font)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - func ==================
extension MovieHeaderView {
	private func setLayout(title: String, font: UIFont) {
		translatesAutoresizingMaskIntoConstraints = false

		updateTitleLabel(title: title, font: font)
		
		addSubview(titleLabel)
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15)
		])
		
		addSubview(moreButton)
		NSLayoutConstraint.activate([
			moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			moreButton.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	private func updateTitleLabel(title: String, font: UIFont) {
		titleLabel.text = title
		titleLabel.font = font
	}
}

