//
//  W_InfoView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class W_InfoView: UIView {
	//MARK: - Properties
	private lazy var weatherInfoBox: UIView = {
		let sv = UIView()
		sv.translatesAutoresizingMaskIntoConstraints = false
		sv.backgroundColor = .weakBlue
		sv.layer.opacity = 0.8
		sv.layer.cornerRadius = 15
		return sv
	}()
	private lazy var weatherInfoStackView: UIStackView = {
		let sv = UIStackView()
		sv.translatesAutoresizingMaskIntoConstraints = false
		sv.axis = .horizontal
		sv.alignment = .center
		sv.distribution = .fillEqually
		sv.addArrangedSubview(rainStackView)
		sv.addArrangedSubview(windStackView)
		sv.addArrangedSubview(dustStackView)
		return sv
	}()
	private var rainStackView: W_InfoItemStackView!
	private var windStackView: W_InfoItemStackView!
	private var dustStackView: W_InfoItemStackView!


	//MARK: - Lifecycle
	init(isRain: Bool, rainAmount: String, windAmount: String, dustAmount: String) {
		super.init(frame: .zero)

		layout(isRain: isRain, rainAmount: rainAmount, windAmount: windAmount, dustAmount: dustAmount)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	//MARK: - FUNC==============================
	func layout(isRain: Bool, rainAmount: String, windAmount: String, dustAmount: String) {
		rainStackView = W_InfoItemStackView(imageName: isRain ? "rain-icon" : "snow-icon", amountText: isRain ? rainAmount : "0.0mm")
		windStackView = W_InfoItemStackView(imageName: "wind-icon", amountText: windAmount)
		dustStackView = W_InfoItemStackView(imageName: "dust-icon", amountText: dustAmount)


		translatesAutoresizingMaskIntoConstraints = false
		addSubview(weatherInfoBox)
		weatherInfoBox.addSubview(weatherInfoStackView)
		NSLayoutConstraint.activate([
			weatherInfoStackView.leadingAnchor.constraint(equalTo: weatherInfoBox.leadingAnchor),
			weatherInfoStackView.trailingAnchor.constraint(equalTo: weatherInfoBox.trailingAnchor),
			weatherInfoStackView.bottomAnchor.constraint(equalTo: weatherInfoBox.bottomAnchor, constant: -10),
			weatherInfoStackView.topAnchor.constraint(equalTo: weatherInfoBox.topAnchor, constant: 10),
			weatherInfoBox.topAnchor.constraint(equalTo: topAnchor),
			weatherInfoBox.centerXAnchor.constraint(equalTo: centerXAnchor),
			weatherInfoBox.leadingAnchor.constraint(equalTo: leadingAnchor),
			weatherInfoBox.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}


