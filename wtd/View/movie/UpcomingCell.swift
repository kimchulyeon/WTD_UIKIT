
//
//  upcomingCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/04.
//

import UIKit

class UpcomingCell: UICollectionViewCell {
    //MARK: - properties ==================
    static let identifier = "UpcomingCell"

    var currentImageTask: URLSessionDataTask?
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .myWhite
        v.layer.cornerRadius = 25
        v.clipsToBounds = true
        return v
    }()
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    //MARK: - lifecycle ==================
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        currentImageTask?.cancel()
        currentImageTask = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - func ==================
extension UpcomingCell {
    private func setLayout() {
        backgroundColor = .clear
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        containerView.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    func configure(with movieData: U_Result) {
        currentImageTask?.cancel()
        backgroundImageView.image = nil
        
        if let posterPath = movieData.posterPath {
            currentImageTask = ImageManager.shared.loadImage(from: posterPath, completion: { [weak self] image in
                self?.backgroundImageView.image = image
            })
        } else {
            backgroundImageView.image = UIImage(systemName: "photo")
            backgroundImageView.contentMode = .scaleAspectFit
            backgroundImageView.tintColor = .primary
        }
    }
}

