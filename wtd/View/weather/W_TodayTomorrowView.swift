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
        // 🌈🌈🌈 TODO 🌈🌈🌈 register
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    //MARK: - lifecycle ==================
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
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
    }
}

extension W_TodayTomorrowView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todayList = todayDataList, let tomorrowList = tomorrowDataList else { return 0 }
        if section == 0 {
            return todayList.count
        } else {
            return tomorrowList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        // 🌈🌈🌈 TODO 🌈🌈🌈 CELL 만들기
    }
}
