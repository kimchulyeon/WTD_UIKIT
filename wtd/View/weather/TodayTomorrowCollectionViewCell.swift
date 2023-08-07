//
//  TodayTomorrowCollectionViewCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/19.
//

import UIKit

class TodayTomorrowCollectionViewCell: UICollectionViewCell {
    //MARK: - properties ==================
    static let identifier = "TodayTomorrowCollectionViewCell"
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 5
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.addArrangedSubview(tempImage)
        sv.addArrangedSubview(dateLabel)
//        sv.addArrangedSubview(tempLabel)
        return sv
    }()
    private let tempLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.adjustsFontSizeToFitWidth = true
        lb.textColor = UIColor.black
        return lb
    }()
    private let tempImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.adjustsFontSizeToFitWidth = true
        lb.textColor = UIColor.darkGray
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
    
    //MARK: - func ==================
    private func setLayout() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.weakBlue.cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 4.0
        contentView.clipsToBounds = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    func configure(with data: HourlyList) {
        let HOUR = CommonUtil.formatOnlyHourNumber(date: data.dtTxt)
        tempLabel.text = CommonUtil.formatTeperatureToString(temperature: data.main.temp)
        tempImage.image = UIImage(named: CommonUtil.getImageName(with: data.weather[0].main, timeForTodayTomorrowView: HOUR))
        dateLabel.text = CommonUtil.formatHour(date: data.dtTxt)
    }
}
