//
//  MovieVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class MovieVC: UIViewController {
    //MARK: - properties ==================
    typealias Section = MovieQuery
    typealias Item = MovieItem
    
    let vm: MovieViewModel

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

    //MARK: - Lifecycle
    init(viewModel: MovieViewModel) {
        vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        CommonUtil.configureBasicView(for: self)
        CommonUtil.configureNavBar(for: self)
        setLayout()
        configureCollectionView()
        configureDataSource()
        configureSnapshot()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    /// 콜렉션뷰 셀 등록, 레이아웃 설정
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: true)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.identifier)
        collectionView.register(UpcomingCell.self, forCellWithReuseIdentifier: UpcomingCell.identifier)
        collectionView.register(MovieSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieSectionHeader.identifier)
    }

    /// 콜렉션뷰 compositional layout
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, env in
            guard let weakSelf = self else { fatalError("Error while creating collection view layout ❌") }
            return weakSelf.createSection(by: sectionIndex)
        })
    }

    /// 컬렉션뷰 레이아웃
    private func createSection(by index: Int) -> NSCollectionLayoutSection {
        let IS_NOW_SECTION = (index == 0)

        if IS_NOW_SECTION {
            return createNowSection()
        } else {
            return createUpcomingSection()
        }
    }

    /// 상영중인 영화 섹션 생성
    private func createNowSection() -> NSCollectionLayoutSection {
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 35, trailing: 10)
        section.boundarySupplementaryItems = [titleSupplementary]
        return section
    }

    /// 상영예정인 영화 섹션 생성
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
            guard kind == UICollectionView.elementKindSectionHeader,
                  let weakSelf = self,
                  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieSectionHeader.identifier, for: indexPath) as? MovieSectionHeader else { return nil }

            header.delegate = self

            let section = weakSelf.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .now_playing:
                header.configure(title: .now_playing)
            case .upcoming:
                header.configure(title: .upcoming)
            default:
                break
            }
            return header
        }
    }

    // datasource에 snapshot을 넣어준다
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        let nowPlayingMovies: [Result] = vm.nowPlayingMovieList
        let upcomingMovies: [Result] = vm.upcomingMovieList

        let nowMovieItem = nowPlayingMovies.map { Item.oneItemCell($0) }
        var upcomingMovieItem: [Item] = []

        // 상영예정인 영화 전체 개수가 홀수일 때 하나 제거
        if upcomingMovies.count % 2 == 0 {
            upcomingMovieItem = upcomingMovies.map { Item.twoItemCell($0) }
        } else {
            var lastItemRemoved = upcomingMovies.map { Item.twoItemCell($0) }
            var _ = lastItemRemoved.popLast()
            upcomingMovieItem = lastItemRemoved
        }

        snapshot.appendSections([Section.now_playing])
        snapshot.appendItems(nowMovieItem, toSection: Section.now_playing)

        snapshot.appendSections([Section.upcoming])
        snapshot.appendItems(upcomingMovieItem, toSection: Section.upcoming)

        dataSource?.apply(snapshot)
    }

    /// 상세보기 탭으로 이동
    private func moveToDetailWith(data: Result) {
        let detailView = MovieDetailVC(movieData: data)
        detailView.genreList = vm.genreList
        detailView.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailView, animated: true)
    }

    /// 전체보기 탭으로 이동
    private func moveToMoreWith(section: Section) {
        let moreMovieVC = MoreMovieVC(nibName: nil, bundle: nil)
        moreMovieVC.viewModel = vm
        moreMovieVC.movieSection = section
        moreMovieVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(moreMovieVC, animated: true)
    }
}

//MARK: - UICollectionViewDelegate ==================
extension MovieVC: UICollectionViewDelegate {
    /// 셀 선택 시 상세탭으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            moveToDetailWith(data: vm.nowPlayingMovieList[indexPath.row])
        case 1:
            moveToDetailWith(data: vm.upcomingMovieList[indexPath.row])
        default:
            break
        }
    }
}

//MARK: - SectionHeaderDelegate ==================
extension MovieVC: MovieSectionHeaderDelegate {
    /// 전체 보기 버튼 탭 시 전체 보기 탭으로 이동
    func didTapMoreButton(at section: Section) {
        switch section {
        case .now_playing:
            moveToMoreWith(section: section)
        case .upcoming:
            moveToMoreWith(section: section)
        }
    }
}

