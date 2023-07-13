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
        sv.isHidden = true
        return sv
    }()
    private let headerView = W_HeaderView()
    private let tempView = W_TemperatureView()
    private let infoView = W_InfoView(isRain: true, rainAmount: "0.0mm", windAmount: "0.0km/h", dustAmount: "0")
    private let activityIndicator = PrimaryActivityIndicator(style: .large)

    let vm = WeatherViewModel()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setViewWithData()
        setViewAfterLoading()
    }

    //MARK: - FUNC==============================
    private func setNavBar() {
        navigationController?.navigationBar.tintColor = UIColor.primary
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .plain, target: self, action: #selector(handleTapAirplane))
    }

    private func setLayout() {
        setNavBar()
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

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
        vm.setViewWithFetchData { [weak self] weatherData, dustData, cityName, todayDate in
            self?.updateUI(with: weatherData, dustData, cityName, todayDate)
        }
    }


    private func updateUI(with weatherData: WeatherResponse?, _ dustData: DustResponse?, _ city: String, _ today: String) {
        DispatchQueue.main.async { [weak self] in
//            print("도시명 : \(city) :::::::🚀")
//            print("오늘날짜 : \(today) :::::::🚀")
//            print("현재 날씨 응답값 : \(weatherData!) :::::::🚀")
//            print("================================================")
//            print("현재 미세먼지 응답값 : \(dustData!) :::::::🚀")
            self?.headerView.updateLabels(with: city, today)
//            if weatherData?.rain != nil {
//                self?.infoView.layout(isRain: true, rainAmount: weatherData?.rain?.rain1h.description, windAmount: weatherData?.wind.speed.description, dustAmount: dustData?.list[0].components.pm10.description)
//            } else {
//                self?.infoView.layout(isRain: false, rainAmount: weatherData?.snow?.snow1h, windAmount: weatherData?.wind.speed, dustAmount: dustData?.list[0].components.pm10)
//            }
        }
    }
    
    private func setViewAfterLoading() {
        vm.afterFinishLoading = { [weak self] in
            self?.showViewAfterLoading()
        }
    }
    
    private func showViewAfterLoading() {
        if vm.currentWeatherLoading {
            scrollView.isHidden = true
            activityIndicator.startAnimating()
        } else {
            scrollView.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
    
    private func showAlertWithMessage(_ message: String, shouldUpdateLocation: Bool) {
        let alert = UIAlertController(title: "위치 업데이트", message: message, preferredStyle: .alert)
        
        let okActionTitle = shouldUpdateLocation ? "업데이트" : "확인"
        let okActionStyle = shouldUpdateLocation ? UIAlertAction.Style.default : UIAlertAction.Style.destructive
        
        let okAction = UIAlertAction(title: okActionTitle, style: okActionStyle) { _ in
            if shouldUpdateLocation {
                self.vm.updateLocation()
            }
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }


    @objc func handleTapAirplane() {
        if vm.locationManager.canUpdateLocation() {
            showAlertWithMessage("위치를 업데이트하시겠습니까?", shouldUpdateLocation: true)
        } else {
            showAlertWithMessage("5km 이상 이동하거나 5분 뒤에 가능합니다", shouldUpdateLocation: false)
        }
    }
}
