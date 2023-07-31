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
        iv.contentMode = .scaleAspectFill
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
        return lb
    }()
    private let originTitleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let genreLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "장르 들어갈 곳"
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
			backgroundImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(originTitleLabel)
        stackView.addArrangedSubview(genreLabel)
        
		backgroundImageView.addSubview(stackView)
        NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 15),
			stackView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 15),
        ])
    }
	
	public func configure(with movieData: N_Result) {
		titleLabel.text = movieData.title
        originTitleLabel.text = movieData.originalTitle
		ImageManager.shared.loadImage(from: movieData.backdropPath, completion: { [weak self] image in
			self?.backgroundImageView.image = image
		})
	}
}
