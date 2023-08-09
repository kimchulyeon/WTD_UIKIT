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
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<MovieQuery, MovieItem>?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        CommonUtil.configureBasicView(for: self)
        setLayout()
        configureCollectionView()
        configureDataSource()
        configureSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}


//MARK: - func ==================
extension MovieVC {
    private func setLayout() {
        view.addSubview(collectionView)
		collectionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    /// 콜렉션뷰 셀 등록, 레이아웃 설정
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(configureCollectionViewLayout(), animated: true)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.identifier)
        collectionView.register(UpcomingCell.self, forCellWithReuseIdentifier: UpcomingCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
    }

    /// 콜렉션뷰 compositional layout
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, env in
            return self?.createSection(for: sectionIndex)
        })
    }

    /// 컬렉션뷰 레이아웃
    private func createSection(for index: Int) -> NSCollectionLayoutSection {
        let IS_NOW_SECTION = (index == 0)

        if IS_NOW_SECTION {
            return createNowSection()
        } else {
            return createUpcomingSection()
        }
    }
    
    private func createNowSection() -> NSCollectionLayoutSection {
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(450))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 35, trailing: 10)
        section.boundarySupplementaryItems = [titleSupplementary]
        return section
    }
    
    private func createUpcomingSection() -> NSCollectionLayoutSection {
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        var group: NSCollectionLayoutGroup
        
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        }
        group.interItemSpacing = .fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
        section.boundarySupplementaryItems = [titleSupplementary]
        return section
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .oneItemCell(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.identifier, for: indexPath) as? NowPlayingCell else { return UICollectionViewCell() }
                cell.configure(with: data)
                return cell
            case .twoItemCell(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingCell.identifier, for: indexPath) as? UpcomingCell else { return UICollectionViewCell() }
                cell.configure(with: data)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader
            
            let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .now_playing:
                header?.configure(title: "상영중인 영화")
            case .upcoming:
                header?.configure(title: "상영예정인 영화")
            default:
                break
            }
            return header
        }
    }
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieQuery, MovieItem>()
        guard let nowPlayingMovies: [N_Result] = vm.nowPlayingList?.results else { return }
        guard let upcomingMovies: [U_Result] = vm.upcomingList?.results else { return }
		
        let nowMovieItem = nowPlayingMovies.map { MovieItem.oneItemCell($0) }
        var upcomingMovieItem: [MovieItem] = []
        
        if upcomingMovies.count % 2 == 0 {
            upcomingMovieItem = upcomingMovies.map { MovieItem.twoItemCell($0) }
        } else {
            var lastItemRemoved = upcomingMovies.map { MovieItem.twoItemCell($0) }
            var _ = lastItemRemoved.popLast()
            upcomingMovieItem = lastItemRemoved
        }
        
        snapshot.appendSections([MovieQuery.now_playing])
		snapshot.appendItems(nowMovieItem, toSection: MovieQuery.now_playing)
        
        snapshot.appendSections([MovieQuery.upcoming])
        snapshot.appendItems(upcomingMovieItem, toSection: MovieQuery.upcoming)
        
        dataSource?.apply(snapshot)
    }
}

//MARK: - UICollectionViewDelegate ==================
extension MovieVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let data = vm.nowPlayingList?.results[indexPath.item] else { return }
            let detailView = MovieDetailVC(movieData: data, viewModel: vm)
            detailView.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(detailView, animated: true)
        case 1:
            guard let data = vm.upcomingList?.results[indexPath.row] else { return }
            print(data)
        default:
            break
        }
    }
}
