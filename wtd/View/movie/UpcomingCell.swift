
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
    
    private let shadowContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 1)
        v.layer.shadowOpacity = 0.3
        v.layer.shadowRadius = 4.0
        return v
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        return v
    }()
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
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
        
        addSubview(shadowContainerView)
        NSLayoutConstraint.activate([
            shadowContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowContainerView.topAnchor.constraint(equalTo: topAnchor),
            shadowContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        shadowContainerView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: shadowContainerView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: shadowContainerView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: shadowContainerView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: shadowContainerView.bottomAnchor),
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
                if let image = image {
                    DispatchQueue.main.async {
                        self?.backgroundImageView.image = image
                        self?.backgroundImageView.contentMode = .scaleAspectFill
                    }
                }
            })
        } else {
            setPlaceHolderImage()
        }
    }
    
    private func setPlaceHolderImage() {
        DispatchQueue.main.async { [weak self] in
            self?.backgroundImageView.image = UIImage(systemName: "xmark.app")?.resized(to: CGSize(width: 30, height: 30))?.withTintColor(.primary)
            self?.backgroundImageView.contentMode = .center
        }
    }
}

