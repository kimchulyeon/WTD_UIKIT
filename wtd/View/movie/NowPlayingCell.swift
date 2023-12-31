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

    private let shadowContainerView = ShadowView()

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
extension NowPlayingCell {
    private func setLayout() {
        contentView.backgroundColor = .clear

        contentView.addSubview(shadowContainerView)
        NSLayoutConstraint.activate([
            shadowContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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

    func configure(with movieData: Result) {
        currentImageTask?.cancel()
        backgroundImageView.image = nil

        if let posterPath = movieData.posterPath {
            currentImageTask = ImageManager.shared.loadImage(from: posterPath, completion: { [weak self] image in
                if let image = image {
                    DispatchQueue.main.async {
                        self?.backgroundImageView.image = image
                    }
                }
            })
        } else {
            setPlaceholderImage()
        }
    }

    private func setPlaceholderImage() {
        DispatchQueue.main.async { [weak self] in
            self?.backgroundImageView.image = UIImage(systemName: "square.slash")?.resized(to: CGSize(width: 30, height: 30))?.withTintColor(.primary)
            self?.backgroundImageView.contentMode = .center
        }
    }
}
