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
    var vm: WeatherViewModel!
    
    private var requestPermissionView: RequestLocationView? // 위치 권한 거절일 때 보여주는 뷰
    private var isRequestPermissionViewShown = false // requestPermissionView가 2개가 생성되는 문제 해결
    private lazy var activityIndicator = PrimaryActivityIndicator(style: .medium)
    private let containerScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isHidden = true
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    private let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    private let headerView = WeatherHeaderView() // 도시명, 오늘 날짜
    private let tempView = TemperatureView() // 날씨 이미지와 현재 온도, 설명 라벨
    private let infoView = WeatherInfoView() // 강수, 풍속, 미세먼지 뷰
    private let todayTomorrowView = WeatherTodayTomorrowView() // 오늘 | 내일 3시간별 날씨 예보 뷰


    //MARK: - Lifecycle
    init(viewModel: WeatherViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleLocationAuthorizationChange(_:)),
                                               name: Notification.Name("locationAuthorizationChanged"),
                                               object: nil)
        
        CommonUtil.configureBasicView(for: self)
        CommonUtil.configureNavBar(for: self)
        configureViewWithInitialLocationStatus()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: - FUNC==============================
extension WeatherVC {
    /// 앱 최초 실행 시 사용자에게 받은 위치 권한으로 뷰 구성
    private func configureViewWithInitialLocationStatus() {
        let status = LocationManager.shared.locationManager.authorizationStatus
        setViewWithStatus(status)
    }

    /// 앱 최초 실행 시 사용자에게 받은 위치 권한으로 뷰 구성
    private func setViewWithStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            if !isRequestPermissionViewShown {
                setDisagreeLocationView()
                isRequestPermissionViewShown = true
            }
        case .authorizedAlways, .authorizedWhenInUse:
            if isRequestPermissionViewShown {
                requestPermissionView?.removeFromSuperview()
                requestPermissionView = nil
                isRequestPermissionViewShown = false
            }
            setLayout()
            setViewWithData()
            setViewAfterLoading()
        default:
            break
        }
    }

    /// 사용자 위치권한이 허용되어 있지 않을 때 뷰 구성
    private func setDisagreeLocationView() {
        containerScrollView.isHidden = true
        requestPermissionView = RequestLocationView(message: "날씨")
        if let requestPermissionView = requestPermissionView {
            view.addSubview(requestPermissionView)
            requestPermissionView.backgroundColor = .myWhite
            NSLayoutConstraint.activate([
                requestPermissionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                requestPermissionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                requestPermissionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
                requestPermissionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            ])
        }
    }

    /// 설정앱에서 위치권한 변경 시
    @objc func handleLocationAuthorizationChange(_ noti: Notification) {
        // 다음에 묻기는 바로 적용 안됨
        if let status = noti.object as? CLAuthorizationStatus {
            DispatchQueue.main.async { [weak self] in
                self?.setViewWithStatus(status)
            }
        }
    }

    /// 오토레이아웃 + 뼈대
    private func setLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(containerScrollView)
        NSLayoutConstraint.activate([
            containerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerScrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        containerScrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor)
        ])

        containerView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            headerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])

        containerView.addSubview(tempView)
        NSLayoutConstraint.activate([
            tempView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tempView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            tempView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        containerView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: tempView.bottomAnchor, constant: 25),
            infoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            infoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
        ])

        containerView.addSubview(todayTomorrowView)
        NSLayoutConstraint.activate([
            todayTomorrowView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 15),
            todayTomorrowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            todayTomorrowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            todayTomorrowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
        ])
    }

    /// 전달받은 API 응답값 데이터들을 뷰에 전달
    private func setViewWithData() {
        print("🐞🐞🐞🐞🐞🐞🐞🐞🐞")
        vm.injectFetchDataToViews { [weak self] weatherData, dustData, todayData, tomorrowData, cityName, todayDate in
            self?.updateUI(with: weatherData, dustData, todayData, tomorrowData, cityName, todayDate)
        }
    }

    /// indicator랑 뷰 isHidden 설정
    private func setViewAfterLoading() {
        vm.afterFinishLoading = { [weak self] in
            self?.handleLoadingIndicator()
        }
    }

    /// indicator랑 뷰 isHidden 설정
    private func handleLoadingIndicator() {
        if vm.currentWeatherLoading {
            containerScrollView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            containerScrollView.isHidden = false
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }

    /// 전달받은 데이터들로 뷰 구성
    private func updateUI(with weatherData: WeatherResponse?,
                          _ dustData: DustResponse?,
                          _ todayData: [HourlyList]?,
                          _ tomorrowData: [HourlyList]?,
                          _ city: String,
                          _ today: String?)
    {
        guard let weatherData = weatherData,
              let dustData = dustData,
              let todayData = todayData,
              let tomorrowData = tomorrowData,
              let today = today else { return }

        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.updateHeaderView(with: city, today)
            weakSelf.updateTempView(with: weatherData)
            weakSelf.updateInfoView(with: weatherData, dustData)
            weakSelf.updateTodayTomorrowView(with: todayData, tomorrowData)
        }
    }

    /// 헤더 : 도시, 날짜 업데이트
    private func updateHeaderView(with city: String, _ today: String) {
        headerView.updateLabels(with: city, today)
    }

    /// 이미지, 현재온도 뷰 데이터로 업데이트
    private func updateTempView(with data: WeatherResponse) {
        var idx = 0
        if data.weather.count > 1 {
            idx = Int.random(in: 0..<data.weather.count)
        }
        
        let weatherCondition = data.weather[idx].main
        let tempValue = CommonUtil.formatTeperatureToString(temperature: data.main.temp)
        let weatherImageName = CommonUtil.getWeatherImageName(with: weatherCondition, timeForTodayTomorrowView: nil)
        let tempDesc = data.weather[idx].description
        tempView.configure(imageName: weatherImageName, tempValue: tempValue, tempDesc: tempDesc)
    }

    /// 강수 / 풍속 / 미세먼지 뷰 데이터로 업데이트
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
        } else if let snowData = weatherData.snow {
            rainOrSnowAmount = CommonUtil.formatRainOrSnowAmountToString(amount: snowData.snow1h)
        }

        infoView.configureView(isRain: isRain, rainOrSnowAmount: rainOrSnowAmount, windAmount: windSpeed, dustAmount: dustAmount)
    }

    /// 오늘 내일 시간별 날씨 뷰 데이터로 업데이트
    private func updateTodayTomorrowView(with today: [HourlyList], _ tomorrow: [HourlyList]) {
        todayTomorrowView.configure(today: today, tomorrow: tomorrow)
    }
}
