//
//  W_TodayTomorrowView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/18.
//

import UIKit

class WeatherTodayTomorrowView: UIView {
    //MARK: - properties ==================
    private var todayDataList: [HourlyList]? = nil
    private var tomorrowDataList: [HourlyList]? = nil

    private var tableView: UITableView? = nil

    //MARK: - lifecycle ==================
    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - func ==================
    private func setLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// 데이터로 화면 그리기
    func configure(today: [HourlyList], tomorrow: [HourlyList]) {
        todayDataList = today
        tomorrowDataList = tomorrow

        configureTableView()
        tableView?.reloadData()
    }

    /// 테이블뷰 구성
    func configureTableView() {
        guard tableView == nil else { return }
        tableView = UITableView()
        guard let tableView = tableView else { return }

        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(TodayTomorrowTableViewCell.self, forCellReuseIdentifier: TodayTomorrowTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            tableView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
}

extension WeatherTodayTomorrowView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return TodayTomorrowHeaderView(title: "오늘 시간별 날씨")
        } else if section == 1 {
            return TodayTomorrowHeaderView(title: "내일 시간별 날씨")
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayTomorrowTableViewCell.identifier, for: indexPath) as? TodayTomorrowTableViewCell,
                let todayData = todayDataList else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.passDatasToTableCell(todayData)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayTomorrowTableViewCell.identifier, for: indexPath) as? TodayTomorrowTableViewCell,
                let tomorrowData = tomorrowDataList else { return UITableViewCell() }

            cell.backgroundColor = .clear
            cell.passDatasToTableCell(tomorrowData)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
