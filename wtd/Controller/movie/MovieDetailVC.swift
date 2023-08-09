//
//  MovieDetailVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/08.
//

import UIKit
import youtube_ios_player_helper

class MovieDetailVC: UIViewController {
    //MARK: - properties ==================
    let data: Result
    private var genreList: [Genre]?
    private var videoURL: String? = nil
    private var videoUrlKey: String? = nil

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
    private lazy var playButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "play.fill")?.withTintColor(.primary).resized(to: CGSize(width: 30, height: 30)), for: .normal)
        btn.backgroundColor = UIColor(white: 1, alpha: 0.5)
        btn.layer.cornerRadius = 25
        btn.isHidden = true
        btn.addTarget(self, action: #selector(tapPlayButton), for: .touchUpInside)
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
    private lazy var genreCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createGenreCollectionViewLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        return cv
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
    private lazy var playerView: YTPlayerView = {
        let pv = YTPlayerView()
        pv.delegate = self
        return pv
    }()

    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()

        MovieService.shared.getMovieVideoUrl(id: data.id) { [weak self] data in
            guard let data = data else { return }
            if data.count > 0 {
                let randomIndex = Int.random(in: 0..<data.count)
                self?.videoURL = CommonUtil.formatFullVideoUrl(url: data[randomIndex].key)
                self?.videoUrlKey = data[randomIndex].key

                DispatchQueue.main.async {
                    self?.playButton.isHidden = false
                    self?.view.layoutIfNeeded()
                }
            }
        }
        setLayout()
    }

    init(movieData: Result, viewModel: MovieViewModel) {
        data = movieData
        genreList = viewModel.genreList
        super.init(nibName: nil, bundle: nil)
        updateViewWith(data: data)
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

        containerView.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
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

        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: gradeLabel.bottomAnchor, constant: 15),
        ])

        containerView.addSubview(originTitleLabel)
        NSLayoutConstraint.activate([
            originTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            originTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            originTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])

        containerView.addSubview(genreCollectionView)
        NSLayoutConstraint.activate([
            genreCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            genreCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            genreCollectionView.topAnchor.constraint(equalTo: originTitleLabel.bottomAnchor, constant: 15),
            genreCollectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            genreCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])

        containerView.addSubview(overViewLabel)
        NSLayoutConstraint.activate([
            overViewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 17),
            overViewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            overViewLabel.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor, constant: 15),
            overViewLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        ])
    }

    private func updateViewWith(data: Result) {
        if let path = data.posterPath {
            ImageManager.shared.loadImage(from: path) { [weak self] image in
                self?.posterImageView.image = image
            }
        }

        gradeLabel.text = data.voteAverage.description
        openDateLabel.text = data.releaseDate
        titleLabel.text = data.title
        originTitleLabel.text = data.originalTitle
        overViewLabel.text = data.overview
    }

    private func createGenreCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return layout
    }

    private func getGenreString(id: Int) -> String? {
        var genreStr: String?
        genreList?.forEach { genre in
            if genre.id == id {
                genreStr = genre.name
            }
        }
        return genreStr
    }

    @objc func tapPlayButton() {
        guard let key = videoUrlKey else { return }

        let playerVars = ["playsinline": 0, "showinfo": 0, "rel": 0] as [String: Any]

        playerView.load(withVideoId: key, playerVars: playerVars)

        containerView.addSubview(playerView)
        playerView.frame = posterImageView.bounds
        playerView.alpha = 0
    }
}


//MARK: - UICollectionViewDataSource ==================
extension MovieDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.genreIDS.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.identifier, for: indexPath) as? GenreCell else { return UICollectionViewCell() }
        let id = data.genreIDS[indexPath.item]
        if let genreStr = getGenreString(id: id) {
            cell.configure(genreString: genreStr)
        }
        return cell
    }
}

extension MovieDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let id = data.genreIDS[indexPath.item]
        guard let text = getGenreString(id: id) else { return CGSize(width: 0, height: 0) }
        let font = UIFont.systemFont(ofSize: 13)
        let textSize = (text as NSString).size(withAttributes: [.font: font])
        let width = textSize.width + 25
        return CGSize(width: width, height: 35)
    }
}

//MARK: - YTPlayerViewDelegate ==================
extension MovieDetailVC: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        UIView.animate(withDuration: 0.5) {
            self.playerView.alpha = 1
        }
        playerView.playVideo()
    }
}
