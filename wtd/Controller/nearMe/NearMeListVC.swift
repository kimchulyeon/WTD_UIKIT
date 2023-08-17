//
//  NearMeListVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/17.
//

import UIKit

class NearMeListVC: UIViewController {
    //MARK: - properties ==================
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
}

//MARK: - func ==================
extension NearMeListVC {
    private func setLayout() {
        
    }
}

//MARK: - UITableViewDelegate ==================
extension NearMeListVC: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource ==================
extension NearMeListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
