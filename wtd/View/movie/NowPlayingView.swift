//
//  NowPlayingView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/29.
//

import UIKit

class NowPlayingView: UIView {
	enum Section {
		case main
	}
	typealias Item = N_Result
	//MARK: - properties==============================
	var vm: MovieViewModel!
	var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
	private lazy var collectionView: UICollectionView = {
		let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.showsHorizontalScrollIndicator = false
		cv.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.identifier)
		cv.delegate = self
		return cv
	}()
	
	//MARK: - lifecycle==============================
	init(viewModel: MovieViewModel) {
		vm = viewModel
		super.init(frame: .zero)
		
		dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
			
			return nil
		})
		setLayout()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//MARK: - func==============================
extension NowPlayingView {
	private func setLayout() {
		translatesAutoresizingMaskIntoConstraints = false
		
		backgroundColor = .yellow
	}
	
	/// 콜렉션 뷰 레이아웃
	private func createLayout() -> UICollectionViewLayout {
		return UICollectionViewLayout()
	}
}

//MARK: - UICollectionViewDelegate ==============================
extension NowPlayingView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return vm.nowPlayingList?.results.count ?? 0
	}
}
