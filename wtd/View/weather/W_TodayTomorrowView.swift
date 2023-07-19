//
//  W_TodayTomorrowView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/18.
//

import UIKit

class W_TodayTomorrowView: UIView {
    //MARK: - properties ==================
    private var todayDataList: [HourlyList]? = nil
    private var tomorrowDataList: [HourlyList]? = nil

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(TodayTomorrowTableViewCell.self, forCellReuseIdentifier: TodayTomorrowTableViewCell.identifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

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
        backgroundColor = .red
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }

    /// 데이터로 화면 그리기
    func configure(today: [HourlyList], tomorrow: [HourlyList]) {
        print(#fileID, #function, #line)
        todayDataList = today
        tomorrowDataList = tomorrow
        tableView.reloadData()
    }
}

extension W_TodayTomorrowView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "오늘 날씨"
        } else if section == 1 {
            return "내일 날씨"
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayTomorrowTableViewCell.identifier, for: indexPath) as? TodayTomorrowTableViewCell,
            let todayData = todayDataList, let tomorrowData = tomorrowDataList
            else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.passDatasToTableCell(todayData)
        } else if indexPath.section == 1 {
            cell.passDatasToTableCell(tomorrowData)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
