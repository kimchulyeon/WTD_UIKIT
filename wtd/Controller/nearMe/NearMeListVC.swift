//
//  NearMeListVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/17.
//

import UIKit

protocol NearMeListVCDelegate: AnyObject {
    func loadMoreList()
}

class NearMeListVC: UIViewController {
    //MARK: - properties ==================
    var lists: [Document]?
    weak var delegate: NearMeListVCDelegate?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(NearMeListCell.self, forCellReuseIdentifier: NearMeListCell.identifier)
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .myWhite
        tv.separatorStyle = .none
        return tv
    }()
    
    //MARK: - lifecycle ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonUtil.configureBasicView(for: self)
        CommonUtil.configureNavBar(for: self)
        setLayout()
    }
}

//MARK: - func ==================
extension NearMeListVC {
    private func setLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate ==================
extension NearMeListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK: - UITableViewDataSource ==================
extension NearMeListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lists = lists else { return 0 }
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let lists = lists,
              let cell = tableView.dequeueReusableCell(withIdentifier: NearMeListCell.identifier, for: indexPath) as? NearMeListCell else { return UITableViewCell() }
        cell.configure(data: lists[indexPath.row])
        cell.data = lists[indexPath.row]
        cell.delegate = self
        
        // ✅ TODO ✅
        if indexPath.row == lists.count - 1 {
            print("🐞 DEBUG - \n \(#file)파일 \n \(#function)함수 \n \(#line)줄 \n 이 때 무한스크롤 구현")
            delegate?.loadMoreList()
        }
        
        return cell
    }
}

//MARK: - NearMeListCellDelegate ==================
extension NearMeListVC: NearMeListCellDelegate {
    func didTapLinkIcon(id: String) {
        CommonUtil.moveToKakaoMap(url: "kakaomap://place?id=\(id)", appId: "id304608425")
    }
}
