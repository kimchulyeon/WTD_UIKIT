//
//  WeatherVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    //MARK: - Properties==============================
    var isDayTime: Bool = true
    let vm = WeatherViewModel()

    private let activityIndicator = PrimaryActivityIndicator(style: .large)
    private let containerView: UIView = {
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isHidden = true
        return sv
    }()
    private let headerView = W_HeaderView()
    private let tempView = W_TemperatureView()
    private let infoView = W_InfoView()

//    private let bottomWeatherSummaryView: UIView = {
//        let v = UIView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()

    private var requestPermissionView: RequestLocationView? = nil



    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationAuthorizationChange(_:)), name: Notification.Name("locationAuthorizationChanged"), object: nil)
        
        handleInitialLocationStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkMorningOrNight()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    //MARK: - FUNC==============================
    private func handleInitialLocationStatus() {
        let status = LocationManager.shared.locationManager.authorizationStatus
        handleLocationStatus(status)
    }

    private func handleLocationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            containerView.removeFromSuperview()
            setRequestPermissionView()
        case .authorizedAlways, .authorizedWhenInUse:
            if requestPermissionView != nil {
                requestPermissionView?.removeFromSuperview()
                requestPermissionView = nil
            }

            setNavBar()
            setLayout()
            setViewWithData()
            setViewAfterLoading()
        default:
            break
        }
    }
    private func setRequestPermissionView() {
        containerView.isHidden = true
        requestPermissionView = RequestLocationView()
        if let requestPermissionView = requestPermissionView {
            view.addSubview(requestPermissionView)
            NSLayoutConstraint.activate([
                requestPermissionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                requestPermissionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                requestPermissionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
                requestPermissionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            ])
        }
    }
    private func setNavBar() {
        navigationController?.navigationBar.tintColor = UIColor.primary
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .plain, target: self, action: #selector(handleTapAirplane))
    }

    private func setLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        containerView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            headerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])

        containerView.addSubview(tempView)
        NSLayoutConstraint.activate([
            tempView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tempView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            tempView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30)
        ])

        containerView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: tempView.bottomAnchor, constant: 25),
            infoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            infoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30)
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

    private func showViewAfterLoading() {
        if vm.currentWeatherLoading {
            containerView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            containerView.isHidden = false
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }


    private func updateUI(with weatherData: WeatherResponse?, _ dustData: DustResponse?, _ city: String, _ today: String) {
        guard let weatherData = weatherData, let dustData = dustData else { return }

        DispatchQueue.main.async { [weak self] in
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
}

extension WeatherVC {
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

    @objc func handleTapAirplane() {
        if LocationManager.shared.canUpdateLocation() {
            showAlertWithMessage("위치를 업데이트하시겠습니까?", shouldUpdateLocation: true)
        } else {
            showAlertWithMessage("5km 이상 이동하거나 5분 뒤에 가능합니다", shouldUpdateLocation: false)
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

    @objc func handleLocationAuthorizationChange(_ noti: Notification) {
        print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 설정앱에서 위치 권한 변경함 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
        // 다음에 묻기는 바로 적용 안됨 | 5분 설정 때문에 바꿔도 적용이 안됨 TODO
        if let status = noti.object as? CLAuthorizationStatus {
            handleLocationStatus(status)
        }
    }
}
