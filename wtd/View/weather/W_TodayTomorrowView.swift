//
//  W_TodayTomorrowView.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/18.
//

import UIKit

class W_TodayTomorrowView: UIView {
    //MARK: - properties ==================
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
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
}

extension W_TodayTomorrowView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
