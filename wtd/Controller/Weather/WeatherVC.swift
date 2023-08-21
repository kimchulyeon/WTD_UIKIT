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

    private let dividerView = DividerView()
    private var requestPermissionView: RequestLocationView? // 위치 권한 거절일 때 보여주는 뷰
    private var isRequestPermissionViewShown = false // requestPermissionView가 2개가 생성되는 문제 해결
    private lazy var activityIndicator = PrimaryActivityIndicator(style: .medium)
    private let containerView: UIScrollView = { // 컨테이너 역할 스크롤뷰
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isHidden = true
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    private let contentView: UIView = { // 서브 뷰들의 컨테이너 뷰
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

        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationAuthorizationChange(_:)), name: Notification.Name("locationAuthorizationChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        CommonUtil.configureBasicView(for: self)
        CommonUtil.configureNavBar(for: self)
        configureViewWithInitialLocationStatus()
    }

    deinit {
        print("WEATHER VC DEINIT ❌❌❌❌❌❌❌❌❌❌❌❌")
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: - FUNC==============================
extension WeatherVC {
    /// 앱 최초 실행 시 사용자에게 받은 위치 권한으로 뷰 구성
    private func configureViewWithInitialLocationStatus() {
        let status = LocationManager.shared.locationManager.authorizationStatus
        setViewWith(status)
    }

    /// 앱 최초 실행 시 사용자에게 받은 위치 권한으로 뷰 구성
    private func setViewWith(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            if !isRequestPermissionViewShown {
                setRequestPermissionView()
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
    private func setRequestPermissionView() {
        containerView.isHidden = true
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
                self?.setViewWith(status)
            }
        }
    }

    @objc func willEnterForeground() {
        print("✅✅✅✅✅✅✅✅✅✅✅")
        print(LocationManager.shared.locationManager.authorizationStatus.rawValue)
    }

    /// 오토레이아웃 + 뼈대
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
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        containerView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])

        contentView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            headerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])

        contentView.addSubview(tempView)
        NSLayoutConstraint.activate([
            tempView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tempView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tempView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        contentView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: tempView.bottomAnchor, constant: 25),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
        ])

        contentView.addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 35),
            dividerView.heightAnchor.constraint(equalToConstant: 8),
        ])

        contentView.addSubview(todayTomorrowView)
        NSLayoutConstraint.activate([
            todayTomorrowView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            todayTomorrowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            todayTomorrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            todayTomorrowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }

    /// 전달받은 API 응답값 데이터들을 뷰에 전달
    private func setViewWithData() {
        print("🐞🐞🐞 DEBUG - \n \(#file)파일 \(#line)줄 \(#function)함수 \n 이게 실행되면 UI 업데이트 되는거지? \n 🐞🐞END🐞🐞")

        vm.injectFetchDataToViews { [weak self] weatherData, dustData, todayData, tomorrowData, cityName, todayDate in
            self?.updateUI(with: weatherData, dustData, todayData, tomorrowData, cityName, todayDate)
        }
    }

    /// indicator랑 뷰 isHidden 설정
    private func setViewAfterLoading() {
        vm.afterFinishLoading = { [weak self] in
            self?.showViewAfterLoading()
        }
    }

    /// indicator랑 뷰 isHidden 설정
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

    /// 전달받은 데이터들로 뷰 구성
    private func updateUI(with weatherData: WeatherResponse?, _ dustData: DustResponse?, _ todayData: [HourlyList]?, _ tomorrowData: [HourlyList]?, _ city: String, _ today: String?) {
        guard let weatherData = weatherData, let dustData = dustData, let todayData = todayData, let tomorrowData = tomorrowData, let today = today else { return }

        DispatchQueue.main.async { [weak self] in
            self?.updateHeaderView(with: city, today)
            self?.updateTempView(with: weatherData)
            self?.updateInfoView(with: weatherData, dustData)
            self?.updateTodayTomorrowView(with: todayData, tomorrowData)
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
        let condition = data.weather[idx].main
        let tempValue = CommonUtil.formatTeperatureToString(temperature: data.main.temp)
        let weatherImageName = CommonUtil.getImageName(with: condition, timeForTodayTomorrowView: nil)
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
        }
        if let snowData = weatherData.snow {
            rainOrSnowAmount = CommonUtil.formatRainOrSnowAmountToString(amount: snowData.snow1h)
        }

        infoView.configureView(isRain: isRain, rainOrSnowAmount: rainOrSnowAmount, windAmount: windSpeed, dustAmount: dustAmount)
    }

    /// 오늘 내일 시간별 날씨 뷰 데이터로 업데이트
    private func updateTodayTomorrowView(with today: [HourlyList], _ tomorrow: [HourlyList]) {
        todayTomorrowView.configure(today: today, tomorrow: tomorrow)
    }
}
