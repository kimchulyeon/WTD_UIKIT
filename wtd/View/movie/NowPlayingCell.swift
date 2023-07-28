//
//  NowPlayingCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/28.
//

import UIKit

class NowPlayingCell: UICollectionViewCell {
    //MARK: - properties ==================
    static let identifier = "NowPlayingCell"
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .leading
        return sv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "제목입니다"
        return lb
    }()
    private let genreLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "comedy"
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
}

//MARK: - func ==================
extension NowPlayingCell {
    private func setLayout() {
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .clear
        backgroundColor = .darkGray
        
        addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(genreLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 15),
        ])
    }
}
