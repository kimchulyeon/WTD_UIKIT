//
//  TodayTomorrowCollectionViewCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/20.
//

import UIKit

class TodayTomorrrowCollectionViewCell: UICollectionViewCell {
    //MARK: - properties ==================
    static let identifier = "TodayTomorrrowCollectionViewCell"
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.spacing = 1
        return sv
    }()
    private let tempLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let weatherImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.4
        return lb
    }()
    
    //MARK: - lifecycle ==================
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
//        setLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func ==================
    private func setLayout() {
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(weatherImage)
        stackView.addArrangedSubview(dateLabel)
        
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = UIColor.primary.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with data: HourlyList) {
        tempLabel.text = CommonUtil.formatTeperatureToString(temperature: data.main.temp)
        weatherImage.image = UIImage(named: setWeatherImageNameWith(condition: data.weather[0].main.rawValue))
        dateLabel.text = data.dtTxt
    }
    
    private func setWeatherImageNameWith(condition: String) -> String {
        switch condition {
        case "Clear":
            return  "clear"
        case "Rain":
            return "rain"
        case "Clouds":
            return "cloud"
        case "Snow":
            return "snow"
        case "Extreme":
            return "extreme"
        default:
            return "haze"
        }
    }
}
