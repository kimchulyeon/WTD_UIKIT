//
//  WeatherInfoView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class WeatherInfoView: UIView {
    //MARK: - Properties
    private var weatherInfoBox: ShadowView = {
        let sv = ShadowView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .myWhite
        sv.layer.opacity = 0.8
        sv.layer.cornerRadius = 15
        return sv
    }()
    private var weatherInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - FUNC==============================
    func configureView(isRain: Bool, rainOrSnowAmount: String, windAmount: String, dustAmount: String) {
        resetStackView()

        let rainStackView = WeatherInfoItemStackView(imageName: isRain ? "rain-icon" : "snow-icon", amountText: rainOrSnowAmount, isDust: false)
        let windStackView = WeatherInfoItemStackView(imageName: "wind-icon", amountText: windAmount, isDust: false)
        let dustStackView = WeatherInfoItemStackView(imageName: "dust-icon", amountText: dustAmount, isDust: true)

        addSubview(weatherInfoBox)
        weatherInfoBox.addSubview(weatherInfoStackView)
        weatherInfoStackView.addArrangedSubview(rainStackView)
        weatherInfoStackView.addArrangedSubview(windStackView)
        weatherInfoStackView.addArrangedSubview(dustStackView)
        NSLayoutConstraint.activate([
            weatherInfoBox.topAnchor.constraint(equalTo: topAnchor),
            weatherInfoBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherInfoBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherInfoBox.bottomAnchor.constraint(equalTo: bottomAnchor),
            weatherInfoStackView.leadingAnchor.constraint(equalTo: weatherInfoBox.leadingAnchor),
            weatherInfoStackView.trailingAnchor.constraint(equalTo: weatherInfoBox.trailingAnchor),
            weatherInfoStackView.bottomAnchor.constraint(equalTo: weatherInfoBox.bottomAnchor, constant: -10),
            weatherInfoStackView.topAnchor.constraint(equalTo: weatherInfoBox.topAnchor, constant: 10),
        ])
    }
    
    private func resetStackView() {
        for view in weatherInfoStackView.arrangedSubviews {
            weatherInfoStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}


