//
//  NearMeListCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/18.
//

import UIKit
import WebKit

protocol NearMeListCellDelegate: AnyObject {
    func didTapLinkIcon(id: String)
}

class NearMeListCell: UITableViewCell {
    //MARK: - properties ==================
    static let identifier = "NearMeListCell"
    var data: Document?
    
    weak var delegate: NearMeListCellDelegate?

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .myWhite
        return view
    }()
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fillEqually
        sv.spacing = 1
        sv.addArrangedSubview(nameLabel)
        sv.addArrangedSubview(distanceStackView)
        sv.addArrangedSubview(addressStackView)
        sv.addArrangedSubview(phoneStackView)
        return sv
    }()
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.5
        return lb
    }()
    private lazy var distanceStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.addArrangedSubview(distanceIcon)
        sv.addArrangedSubview(distanceLabel)
        sv.spacing = 3
        return sv
    }()
    private let distanceIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "figure.walk")
        iv.tintColor = .primary
        return iv
    }()
    private let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = .myDarkGray
        return lb
    }()
    private lazy var addressStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.addArrangedSubview(addressIcon)
        sv.addArrangedSubview(addressLabel)
        sv.spacing = 3
        return sv
    }()
    private let addressIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "mappin")
        iv.tintColor = .primary
        return iv
    }()
    private let addressLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    private lazy var phoneStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.addArrangedSubview(phoneIcon)
        sv.addArrangedSubview(phoneLabel)
        sv.spacing = 3
        return sv
    }()
    private let phoneIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "phone")
        iv.tintColor = .primary
        return iv
    }()
    private let phoneLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = .myDarkGray
        return lb
    }()
    private lazy var goToDetailButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "link.circle.fill"), for: .normal)
        btn.tintColor = .primary
        btn.addTarget(self, action: #selector(tapLinkIcon), for: .touchUpInside)
        return btn
    }()

    //MARK: - lifecycle ==================
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - func ==================
extension NearMeListCell {
    private func setLayout() {
        contentView.backgroundColor = .myWhite
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])

        containerView.addSubview(stackView)
        containerView.addSubview(goToDetailButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: goToDetailButton.leadingAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            goToDetailButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            goToDetailButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            goToDetailButton.heightAnchor.constraint(equalToConstant: 50),
            goToDetailButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }

    func configure(data: Document) {
        nameLabel.text = data.placeName
        distanceLabel.text = data.distance + "m"
        addressLabel.text = data.roadAddressName
        phoneLabel.text = data.phone ?? "-"
    }
    
    @objc func tapLinkIcon() {
        guard let data = data else { return }
        delegate?.didTapLinkIcon(id: data.id)
    }
}

