//
//  MoreMovieVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/10.
//

import UIKit

class MoreMovieVC: UIViewController {
    //MARK: - properties ==================
    var movieSection: MovieQuery?
    var viewModel: MovieViewModel?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(MoreMovieCell.self, forCellWithReuseIdentifier: MoreMovieCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()

        CommonUtil.configureBasicView(for: self)
        setLayout()
    }
    
    deinit {
        print("🐞 DEBUG - MORE MOVIE VC DEINIT:::::::::::")
    }
}

extension MoreMovieVC {
    private func setLayout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout ==================
extension MoreMovieVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 20, height: 330)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch movieSection {
        case .now_playing:
            guard let data = viewModel?.nowPlayingMovieList else { return }
            let detailView = MovieDetailVC(movieData: data[indexPath.row])
            detailView.genreList = viewModel?.genreList
            navigationController?.pushViewController(detailView, animated: true)
        case .upcoming:
            guard let data = viewModel?.upcomingMovieList else { return }
            let detailView = MovieDetailVC(movieData: data[indexPath.row])
            detailView.genreList = viewModel?.genreList
            navigationController?.pushViewController(detailView, animated: true)
        default:
            break
        }
    }
}

//MARK: - UICollectionViewDataSource ==================
extension MoreMovieVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch movieSection {
        case .now_playing:
            guard let list = viewModel?.nowPlayingMovieList else { return 0 }
            return list.count
        case.upcoming:
            guard let list = viewModel?.upcomingMovieList else { return 0 }
            return list.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreMovieCell.identifier, for: indexPath) as? MoreMovieCell else { return UICollectionViewCell() }

        switch movieSection {
        case .now_playing:
            guard let list = viewModel?.nowPlayingMovieList else { return UICollectionViewCell() }
            cell.configure(with: list[indexPath.row])
            
            if indexPath.row == (viewModel?.nowPlayingMovieList.count ?? 0) - 1 {
                viewModel?.loadMoreNowPlaying {
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            }
        case .upcoming:
            guard let list = viewModel?.upcomingMovieList else { return UICollectionViewCell() }
            cell.configure(with: list[indexPath.row])
            
            if indexPath.row == (viewModel?.upcomingMovieList.count ?? 0) - 1 {
                viewModel?.loadMoreNowPlaying {
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            }
        default:
            break
        }
        return cell
    }
}
