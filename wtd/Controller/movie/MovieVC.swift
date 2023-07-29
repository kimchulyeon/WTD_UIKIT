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
	
	private let containerView: UIScrollView = {
		let sv = UIScrollView()
		sv.translatesAutoresizingMaskIntoConstraints = false
		sv.alwaysBounceVertical = true
		sv.showsVerticalScrollIndicator = false
		return sv
	}()
    private var nowHeaderView: MovieHeaderView!
	private var nowPlayingView: NowPlayingView!

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
        nowHeaderView = MovieHeaderView(title: "상영중인 영화", font: UIFont.boldSystemFont(ofSize: 22))
		
		view.addSubview(containerView)
		NSLayoutConstraint.activate([
			containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			containerView.widthAnchor.constraint(equalTo: view.widthAnchor)
		])
		
        containerView.addSubview(nowHeaderView)
        NSLayoutConstraint.activate([
            nowHeaderView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
			nowHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            nowHeaderView.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant: -15),
        ])
		
		nowPlayingView = NowPlayingView(viewModel: vm)
		containerView.addSubview(nowPlayingView)
		NSLayoutConstraint.activate([
			nowPlayingView.topAnchor.constraint(equalTo: nowHeaderView.bottomAnchor, constant: 30),
			nowPlayingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			nowPlayingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			// ✅ TODO ✅
			nowPlayingView.heightAnchor.constraint(equalToConstant: 400)
		])
    }
}
