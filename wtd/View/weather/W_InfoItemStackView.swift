//
//  W_InfoItemStackView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class W_InfoItemStackView: UIStackView {
	//MARK: - Properties
	private let imageView: UIImageView = {
		let iv = UIImageView()
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.contentMode = .scaleAspectFit
		return iv
	}()
	private let amountLabel: UILabel = {
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
		lb.font = UIFont.boldSystemFont(ofSize: 16)
		lb.adjustsFontSizeToFitWidth = true
		lb.minimumScaleFactor = 0.5
		return lb
	}()
	
	//MARK: - Lifecycle
	init(imageName: String, amountText: String) {
		super.init(frame: .zero)
		
		layout(imageName: imageName, amountText: amountText)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - FUNC==============================
	private func layout(imageName: String, amountText: String) {
		amountLabel.text = amountText
		imageView.image = UIImage(named: imageName)
		NSLayoutConstraint.activate([
			imageView.widthAnchor.constraint(equalToConstant: 60),
			imageView.heightAnchor.constraint(equalToConstant: 60),
		])
		
		translatesAutoresizingMaskIntoConstraints = false
		axis = .vertical
		alignment = .center
		spacing = 8
		addArrangedSubview(imageView)
		addArrangedSubview(amountLabel)
		
	}
}

