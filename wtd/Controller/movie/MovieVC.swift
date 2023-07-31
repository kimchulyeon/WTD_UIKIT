//
//  MovieVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class MovieVC: UIViewController {
    //MARK: - properties ==================
    let vm = MovieViewModel()
    private let containerView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<MovieQuery, MovieItem>?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        configureCollectionView()
        configureDataSource()
        configureSnapshot()
    }
}


//MARK: - func ==================
extension MovieVC {
    private func setLayout() {
        collectionView.backgroundColor = .yellow
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(configureCollectionViewLayout(), animated: true)
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.identifier)
    }

    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, env in
            return self?.createSection(for: sectionIndex)
        })
    }

    /// 컬렉션뷰 레이아웃
    private func createSection(for index: Int) -> NSCollectionLayoutSection {
        let IS_NOW_SECTION = (index == 0)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        var group: NSCollectionLayoutGroup

        if IS_NOW_SECTION {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        } else {
            if #available(iOS 16.0, *) {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            }
        }

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .oneItemCell(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.identifier, for: indexPath) as? NowPlayingCell else { return UICollectionViewCell() }
                cell.configure(with: data[indexPath.item])
                return cell
            case .twoItemCell(_):
                return UICollectionViewCell()
            }
        })
    }
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieQuery, MovieItem>()
        guard let nowPlayingMovies: [N_Result] = vm.nowPlayingList?.results else { return }
        snapshot.appendSections([MovieQuery.now_playing])
        snapshot.appendItems([MovieItem.oneItemCell(nowPlayingMovies)], toSection: MovieQuery.now_playing)
        dataSource?.apply(snapshot)
    }
}
