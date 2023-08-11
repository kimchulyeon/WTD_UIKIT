//
//  MoreMovieCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/10.
//

import UIKit

class MoreMovieCell: UICollectionViewCell {
    //MARK: - properties ==================
    static let identifier = "MoreMovieCell"
    
    var currentImageTask: URLSessionDataTask?
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        return iv
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.5
        return lb
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
        imageView.image = UIImage()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoreMovieCell {
    private func setLayout() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
        ])
    }
    
    func configure(with movieData: Result) {
        currentImageTask?.cancel()
        currentImageTask = nil
        
        if let posterPath = movieData.posterPath {
            currentImageTask = ImageManager.shared.loadImage(from: posterPath, completion: { [weak self] image in
                if let image = image {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            })
        } else {
            setPlaceholderImage()
        }
        
        titleLabel.text = movieData.title
    }
    
    private func setPlaceholderImage() {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = UIImage(systemName: "square.slash")?.resized(to: CGSize(width: 30, height: 30))?.withTintColor(.primary)
            self?.imageView.contentMode = .center
        }
    }
}
