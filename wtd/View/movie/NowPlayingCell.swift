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

    var currentImageTask: URLSessionDataTask?

    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .myWhite
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 1)
        v.layer.shadowOpacity = 0.3
        v.layer.shadowRadius = 4.0
        v.clipsToBounds = false
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
extension NowPlayingCell {
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

    func configure(with movieData: N_Result) {
        currentImageTask?.cancel()
        backgroundImageView.image = nil

        if let posterPath = movieData.posterPath {
            currentImageTask = ImageManager.shared.loadImage(from: posterPath, completion: { [weak self] image in
                if let image = image {
                    DispatchQueue.main.async {
                        self?.backgroundImageView.image = image
                    }
                } else {
                    self?.setPlaceholderImage()
                }
            })
        } else {
            setPlaceholderImage()
        }
    }

    private func setPlaceholderImage() {
        DispatchQueue.main.async { [weak self] in
            self?.backgroundImageView.image = UIImage(systemName: "rays")
            self?.backgroundImageView.contentMode = .scaleAspectFit
            self?.backgroundImageView.tintColor = .primary
        }
    }
}
