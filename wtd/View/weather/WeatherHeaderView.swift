//
//  WeatherHeaderView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class WeatherHeaderView: UIView {
	//MARK: - Properties
	private let locationIcon: UIImageView = {
		let iv = UIImageView()
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.contentMode = .scaleAspectFit
		iv.image = UIImage(named: "location-pin")
		return iv
	}()
	private let locationLabel: UILabel = {
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
		lb.text = "서울특별시"
		lb.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		lb.textColor = UIColor.myBlack
		return lb
	}()
	private let todayDateLabel: UILabel = {
		let lb = UILabel()
		lb.translatesAutoresizingMaskIntoConstraints = false
		lb.text = "00월 00일 월요일"
		lb.textColor = UIColor.darkGray
		lb.font = UIFont.systemFont(ofSize: 14, weight: .light)
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

		addSubview(locationIcon)
		NSLayoutConstraint.activate([
			locationIcon.topAnchor.constraint(equalTo: topAnchor, constant: 0),
			locationIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
			locationIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
			locationIcon.widthAnchor.constraint(equalToConstant: 30),
			locationIcon.heightAnchor.constraint(equalToConstant: 30),
		])

		addSubview(locationLabel)
		NSLayoutConstraint.activate([
			locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
			locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8)
		])

		addSubview(todayDateLabel)
		NSLayoutConstraint.activate([
			todayDateLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
			todayDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
		])
	}
	
	func updateLabels(with locationText: String, _ dateString: String) {
		locationLabel.text = locationText
		todayDateLabel.text = dateString
	}
}

