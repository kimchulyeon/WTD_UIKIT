//
//  GenreCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/09.
//

import UIKit

class GenreCell: UICollectionViewCell {
    //MARK: - properties ==================
    static let identifier = "GenreCell"
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .secondary
        v.layer.cornerRadius = 17.5
        v.clipsToBounds = true
        return v
    }()
    private let genreLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .myWhite
        lb.font = UIFont.systemFont(ofSize: 13)
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

extension GenreCell {
    private func setLayout() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        containerView.addSubview(genreLabel)
        NSLayoutConstraint.activate([
            genreLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            genreLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
    
    func configure(genreString: String) {
        genreLabel.text = genreString
    }
}
