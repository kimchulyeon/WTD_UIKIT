//
//  TempView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class W_TemperatureView: UIView {
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
		lb.font = UIFont.systemFont(ofSize: 16, weight: .light)
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
			weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			weatherImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
			weatherImageView.heightAnchor.constraint(equalToConstant: 200),
			weatherImageView.widthAnchor.constraint(equalToConstant: 200),
		])

		addSubview(currentTempStackView)
		NSLayoutConstraint.activate([
			currentTempStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			currentTempStackView.centerXAnchor.constraint(equalTo: weatherImageView.centerXAnchor),
			currentTempStackView.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 5),
			currentTempStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	func configure(imageName: String, tempValue: String, tempDesc: String) {
		weatherImageView.image = UIImage(named: imageName)
		currentTempLabel.text = tempValue
		currentTempDescLabel.text = tempDesc
	}
}


