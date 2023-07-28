//
//  MovieVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class MovieVC: UIViewController {
    //MARK: - properties ==================
    let vm = MovieViewModel()
    var nowView: NowPlayingView!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        vm.fetchMovieDatas()
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("MOVIE VC VIEW WILL APPEAR")
    }
}

//MARK: - func ==================
extension MovieVC {
    private func setLayout() {
        nowView = NowPlayingView(viewModel: vm)
        view.addSubview(nowView)
        NSLayoutConstraint.activate([
            nowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            nowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            nowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            nowView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
