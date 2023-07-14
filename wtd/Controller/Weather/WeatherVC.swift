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
    private let infoView = W_InfoView()
    private let activityIndicator = PrimaryActivityIndicator(style: .large)

    var isDayTime: Bool = true
    
    let vm = WeatherViewModel()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setViewWithData()
        setViewAfterLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkMorningOrNight()
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
    
    private func setViewAfterLoading() {
        vm.afterFinishLoading = { [weak self] in
            self?.showViewAfterLoading()
        }
    }
    
    private func checkMorningOrNight() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "HH"
        let hour = Int(dateFormatter.string(from: Date()))

        if hour! >= 18 || hour! < 6 {
            isDayTime = false
        } else {
            isDayTime = true
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

    
    private func updateUI(with weatherData: WeatherResponse?, _ dustData: DustResponse?, _ city: String, _ today: String) {
        DispatchQueue.main.async { [weak self] in
            guard let weatherData = weatherData, let dustData = dustData else {
                print("ERROR while updating weather view ui with no weather or dust datas :::::::❌")
                return
            }
            
            self?.updateHeaderView(with: city, today)
            self?.updateTempView(with: weatherData)
            self?.updateInfoView(with: weatherData, dustData)
        }
    }
    
    private func updateHeaderView(with city: String, _ today: String) {
        headerView.updateLabels(with: city, today)
    }
    private func updateTempView(with data: WeatherResponse) {
        let condition = data.weather[0].main
        let tempValue = CommonUtil.formatTeperatureToString(temperature: data.main.temp)
        let weatherImageName = setWeatherImageNameWith(condition: condition)
        let tempDesc = data.weather[0].description
        tempView.configure(imageName: weatherImageName, tempValue: tempValue, tempDesc: tempDesc)
    }
    private func updateInfoView(with weatherData: WeatherResponse, _ dustData: DustResponse) {
        var isRain = true
        var rainOrSnowAmount = CommonUtil.formatRainOrSnowAmountToString(amount: 0)
        let windSpeed = CommonUtil.formatWindSpeedToString(speed: weatherData.wind.speed)
        let dustAmount = dustData.list[0].components.pm10.description
        
        if weatherData.snow != nil {
            isRain = false
        }
        
        if let rainData = weatherData.rain {
            rainOrSnowAmount = CommonUtil.formatRainOrSnowAmountToString(amount: rainData.rain1h)
        }
        if let snowData = weatherData.snow {
            rainOrSnowAmount = CommonUtil.formatRainOrSnowAmountToString(amount: snowData.snow1h)
        }
        
        infoView.layout(isRain: isRain, rainOrSnowAmount: rainOrSnowAmount, windAmount: windSpeed, dustAmount: dustAmount)
    }
    
    private func setWeatherImageNameWith(condition: String) -> String {
        switch condition {
        case "Clear":
            return self.isDayTime ? "clear" : "moon"
        case "Rain":
            return "rain"
        case "Clouds":
            return self.isDayTime ? "cloud" : "moon_cloud"
        case "Snow":
            return "snow"
        case "Extreme":
            return "extreme"
        default:
            return self.isDayTime ? "haze" : "moon_cloud"
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
