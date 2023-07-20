//
//  W_TodayTomorrowView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/20.
//

import UIKit

class W_TodayTomorrowView: UIView {
    //MARK: - properties ==================
    var todayData: [HourlyList]?
    var tomorrowData: [HourlyList]?

    private lazy var collectionView: UICollectionView = {
        let layout = configureCollectionViewLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    //MARK: - lifecylcle ==================
    init(_ todayData: [HourlyList], _ tomorrowData: [HourlyList]) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        updateData(todayData, tomorrowData)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - func ==================
    private func updateData(_ today: [HourlyList], _ tomorrow: [HourlyList]) {
        todayData = today
        tomorrowData = tomorrow
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }

    private func setLayout() {
        addSubview(collectionView)
        collectionView.register(TodayTomorrrowCollectionViewCell.self, forCellWithReuseIdentifier: TodayTomorrrowCollectionViewCell.identifier)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }

    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ==================
extension W_TodayTomorrowView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let today = todayData, let tomorrow = tomorrowData else { return 0 }
        switch section {
        case 0:
            return today.count
        case 1:
            return tomorrow.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayTomorrrowCollectionViewCell.identifier, for: indexPath) as? TodayTomorrrowCollectionViewCell, let todayData = todayData, let tomorrowData = tomorrowData else { return UICollectionViewCell() }

        switch indexPath.section {
        case 0:
            cell.configure(with: todayData[indexPath.row])
        case 1:
            cell.configure(with: tomorrowData[indexPath.row])
        default:
            break
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}
