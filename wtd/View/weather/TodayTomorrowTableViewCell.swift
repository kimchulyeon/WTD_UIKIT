//
//  TodayTomorrowTableViewCell.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/19.
//

import UIKit

class TodayTomorrowTableViewCell: UITableViewCell {
    //MARK: - properties ==================
    static let identifier = "TodayTomorrowViewCell"
    var dailyWeatherData: [HourlyList]? = nil

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceVertical = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(TodayTomorrowCollectionViewCell.self, forCellWithReuseIdentifier: TodayTomorrowCollectionViewCell.identifier)
        return cv
    }()

    //MARK: - lifecycle ==================
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - func ==================
    private func setLayout() {
        contentView.addSubview(collectionView)
        contentView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func passDatasToTableCell(_ data: [HourlyList]) {
        dailyWeatherData = data
        collectionView.reloadData()
    }
}


extension TodayTomorrowTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = dailyWeatherData else { return 0 }
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayTomorrowCollectionViewCell.identifier, for: indexPath) as? TodayTomorrowCollectionViewCell, let data = dailyWeatherData else { return UICollectionViewCell() }
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
