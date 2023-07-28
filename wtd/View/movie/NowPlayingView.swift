//
//  NowPlayingView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/28.
//

import UIKit

class NowPlayingView: UIView {
    //MARK: - properties ==================
    var vm: MovieViewModel? = nil

    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "상영중인 영화"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        return lb
    }()
    private let moreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("더보기", for: .normal)
        btn.setTitleColor(.primary, for: .normal)
        btn.backgroundColor = .clear
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.decelerationRate = .fast
        cv.showsHorizontalScrollIndicator = false
        cv.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    //MARK: - lifecycle ==================
    init(viewModel: MovieViewModel) {
        vm = viewModel
        super.init(frame: .zero)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - func ==================
extension NowPlayingView {
    private func setLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        ])

        addSubview(moreButton)
        NSLayoutConstraint.activate([
            moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource ==================
extension NowPlayingView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm?.nowPlayingList?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.identifier, for: indexPath) as? NowPlayingCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: collectionView.frame.height)
    }
}
