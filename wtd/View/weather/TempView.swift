//
//  TempView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class TempView: UIView {
	//MARK: - Properties
	private let weatherImageView: UIImageView = {
		let iv = UIImageView()
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.contentMode = .scaleAspectFit
		iv.image = UIImage(named: "clear")
		return iv
	}()
	private lazy var currentTempStackView: UIStackView = {
		let sv = UIStackView()
		sv.translatesAutoresizingMaskIntoConstraints = false
		sv.axis = .vertical
		sv.spacing = 5
		sv.alignment = .center
		sv.addArrangedSubview(currentTempLabel)
		sv.addArrangedSubview(currentTempDescLabel)
		return sv
	}()
	private let currentTempLabel: UILabel = {
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
		lb.text = "13.32°C"
		lb.font = UIFont.boldSystemFont(ofSize: 30)
		return lb
	}()
	private let currentTempDescLabel: UILabel = {
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
		lb.text = "Sunny"
		lb.font = UIFont.systemFont(ofSize: 20, weight: .light)
		lb.textColor = UIColor.darkGray
		lb.adjustsFontSizeToFitWidth = true
		lb.minimumScaleFactor = 0.5
		return lb
	}()
	
	//MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		layout()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
	}
	
	//MARK: - FUNC==============================
	private func layout() {
		translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(weatherImageView)
		NSLayoutConstraint.activate([
			weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
			weatherImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
			weatherImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
			weatherImageView.heightAnchor.constraint(equalToConstant: 180),
			weatherImageView.widthAnchor.constraint(equalToConstant: 180),
		])

		addSubview(currentTempStackView)
		NSLayoutConstraint.activate([
			currentTempStackView.centerYAnchor.constraint(equalTo: weatherImageView.centerYAnchor),
			currentTempStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
		])
	}
	
	func configure(imageName: String, tempValue: String, tempDesc: String) {
		weatherImageView.image = UIImage(named: imageName)
		currentTempLabel.text = tempValue
		currentTempDescLabel.text = tempDesc
	}
}


