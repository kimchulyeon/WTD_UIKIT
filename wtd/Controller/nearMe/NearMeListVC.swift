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
        
        if indexPath.row == lists.count - 1 {
            // 🌈🌈🌈 TODO 🌈🌈🌈 무한 스크롤
            delegate?.loadMoreList()
        }
        
        return cell
    }
}

//MARK: - NearMeListCellDelegate ==================
extension NearMeListVC: NearMeListCellDelegate {
    func didTapLinkIcon(data: Document) {
        guard let appURL = URL(string: "kakaomap://place?id=\(data.id)") else { return }
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "카카오맵이 설치되어 있지 않습니다", message: nil, preferredStyle: .actionSheet)
            
            let kakaoAction = UIAlertAction(title: "카카오맵 다운로드", style: .default) { _ in
                guard let appStoreURL = URL(string: "https://apps.apple.com/app/id304608425") else { return }
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
            
            let basicMapAction = UIAlertAction(title: "기본지도로 열기", style: .default) { _ in
                if let url = URL(string: "http://maps.apple.com/?q=\(data.y),\(data.x)") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in }
            alert.addAction(kakaoAction)
            alert.addAction(basicMapAction)
            alert.addAction(cancelAction)
            navigationController?.present(alert, animated: true)
        }
    }
}
