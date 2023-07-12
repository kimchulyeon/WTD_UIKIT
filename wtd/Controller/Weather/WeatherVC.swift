//
//  WeatherVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class WeatherVC: UIViewController {
    //MARK: - Properties==============================
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private let headerView = W_HeaderView()
    private let tempView = W_TemperatureView()
    private let infoView = W_InfoView(isRain: true, rainAmount: "0.0mm", windAmount: "12.0km/h", dustAmount: "20")

    let vm = WeatherViewModel()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setViewWithData()
    }

    //MARK: - FUNC==============================
    private func setNavBar() {
        navigationController?.navigationBar.tintColor = UIColor.primary
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .plain, target: self, action: #selector(handleTapAirplane))
    }

    private func setLayout() {
        setNavBar()

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        scrollView.addSubview(tempView)
        NSLayoutConstraint.activate([
            tempView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tempView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tempView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])

        scrollView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: tempView.bottomAnchor, constant: 25),
            infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor)
        ])
    }
    
    private func setViewWithData() {
        vm.setViewWithLocationData { [weak self] weatherData, cityName, todayDate in
            self?.updateUI(with: weatherData, cityName, todayDate)
        }
    }


    private func updateUI(with weatherData: WeatherResponse?, _ city: String, _ today: String) {
        DispatchQueue.main.async { [weak self] in
            print("도시명 : \(city) :::::::🚀")
            print("오늘날짜 : \(today) :::::::🚀")
            print("응답값 : \(weatherData) :::::::🚀")
            self?.headerView.updateLabels(with: city, today)
        }
    }

    @objc func handleTapAirplane() {
        vm.updateLocation()
    }
}
