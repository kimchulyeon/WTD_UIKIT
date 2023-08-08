//
//  MovieDetailVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/08.
//

import UIKit

class MovieDetailVC: UIViewController {
    //MARK: - properties ==================
    let data: N_Result

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .myWhite
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .primary
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(handleTapBackButton), for: .touchUpInside)
        return btn
    }()
    private let starImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "star.circle")
        iv.tintColor = .systemYellow
        return iv
    }()
    private let gradeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let totalGradeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "/ 10"
        lb.textColor = .myDarkGray
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    private let openDateLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .myLightGray
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    private let genreLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.5
        return lb
    }()
    private let originTitleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .myDarkGray
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.adjustsFontSizeToFitWidth = true
        lb.minimumScaleFactor = 0.5
        return lb
    }()
    private let overViewLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()

    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    init(movieData: N_Result) {
        data = movieData
        super.init(nibName: nil, bundle: nil)
        updateViewWith(data: movieData)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieDetailVC {
    private func setLayout() {
        view.backgroundColor = .myWhite
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        containerView.addSubview(posterImageView)
        posterImageView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 550)
        ])
        
        containerView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        containerView.addSubview(starImage)
        NSLayoutConstraint.activate([
            starImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            starImage.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
            starImage.widthAnchor.constraint(equalToConstant: 18)
        ])

        containerView.addSubview(gradeLabel)
        NSLayoutConstraint.activate([
            gradeLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: 10),
            gradeLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
        ])
        
        containerView.addSubview(totalGradeLabel)
        NSLayoutConstraint.activate([
            totalGradeLabel.leadingAnchor.constraint(equalTo: gradeLabel.trailingAnchor, constant: 6),
            totalGradeLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
        ])
        
        containerView.addSubview(openDateLabel)
        NSLayoutConstraint.activate([
            openDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            openDateLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
        ])

        containerView.addSubview(genreLabel)
        NSLayoutConstraint.activate([
            genreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            genreLabel.topAnchor.constraint(equalTo: gradeLabel.bottomAnchor, constant: 15),
        ])

        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 15),
        ])

        containerView.addSubview(originTitleLabel)
        NSLayoutConstraint.activate([
            originTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            originTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            originTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])

        containerView.addSubview(overViewLabel)
        NSLayoutConstraint.activate([
            overViewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 17),
            overViewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            overViewLabel.topAnchor.constraint(equalTo: originTitleLabel.bottomAnchor, constant: 15),
            overViewLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
        ])
    }
    
    private func updateViewWith(data: N_Result) {
        if let path = data.posterPath {
            ImageManager.shared.loadImage(from: path) { [weak self] image in
                self?.posterImageView.image = image
            }
        }
        
        gradeLabel.text = data.voteAverage.description
        openDateLabel.text = data.releaseDate
        genreLabel.text = data.genreIDS.description
        titleLabel.text = data.title
        originTitleLabel.text = data.originalTitle
        overViewLabel.text = data.overview
    }
    
    @objc func handleTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
