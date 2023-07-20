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
        sv.layer.borderWidth = 1
        sv.layer.borderColor = UIColor.primary.cgColor
        sv.layer.cornerRadius = 5
        sv.addArrangedSubview(tempLabel)
        sv.addArrangedSubview(tempImage)
        sv.addArrangedSubview(dateLabel)
        return sv
    }()
    private let tempLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = CommonUtil.formatTeperatureToString(temperature: 20)
        return lb
    }()
    private let tempImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "rain")
        iv.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "19 July"
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
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    func configure(with data: HourlyList) {
        tempLabel.text = CommonUtil.formatTeperatureToString(temperature: data.main.temp)
        dateLabel.text = "wow"
    }
}
