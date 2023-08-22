//
//  NearMeVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit
import CoreLocation

class NearMeVC: UIViewController {
    //MARK: - properties ==================
    let MAX_ZOOM = 4
    let MIN_ZOOM = 2
    var PAGE = 1
    var items: [MTMapPOIItem] = []
    var placeDatas: [Document]?

    private var mapView: MTMapView?
    private var distance: Distance = .TwoAndHalfKilo
    private var isRequestPermissionViewShown = false // requestPermissionView가 2개가 생성되는 문제 해결

    private var requestPermissionView: RequestLocationView? // 위치 권한 거절일 때 보여주는 뷰

    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private lazy var searchTextField: PaddingTextField = {
        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let tf = PaddingTextField(padding: padding)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "장소를 입력하세요"
        tf.borderStyle = .none
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 15
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowOffset = CGSize(width: 0, height: 1)
        tf.layer.shadowOpacity = 0.4
        tf.layer.shadowRadius = 4.0
        return tf
    }()
    private lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("검색", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tintColor = .white
        btn.backgroundColor = .primary
        btn.layer.cornerRadius = 5
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4.0
        btn.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return btn
    }()
    private lazy var categoryCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(NearMeCategoryCell.self, forCellWithReuseIdentifier: NearMeCategoryCell.identifier)
        return cv
    }()
    private lazy var zoomInButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .primary
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4.0
        btn.addTarget(self, action: #selector(handleZoomIn), for: .touchUpInside)
        return btn
    }()
    private lazy var zoomOutButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "minus.magnifyingglass"), for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .primary
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4.0
        btn.addTarget(self, action: #selector(handleZoomOut), for: .touchUpInside)
        return btn
    }()
    private lazy var updateLocationButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "scope"), for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .primary
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4.0
        btn.addTarget(self, action: #selector(handleUpdateCurrentLocation), for: .touchUpInside)
        return btn
    }()
    var goToListViewButtonBottomConstraint: NSLayoutConstraint!
    private lazy var goToListViewButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        configuration.baseBackgroundColor = .primary
        let btn = UIButton()
        btn.configuration = configuration
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .myWhite
        btn.addTarget(self, action: #selector(moveToListView), for: .touchUpInside)
        return btn
    }()
    private let distanceImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "ruler")
        iv.tintColor = .primary
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 11)
        lb.text = "2.5km"
        return lb
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleLocationAuthorizationChange(_:)), name: Notification.Name("locationAuthorizationChanged"), object: nil)

        CommonUtil.configureBasicView(for: self)
        CommonUtil.configureNavBar(for: self)
        navigationController?.navigationBar.isHidden = true
        configureViewWithInitialLocationStatus()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
//        configureViewWithInitialLocationStatus()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.isHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    deinit {
        print("NEAR ME VC DE INIT:::::::::::::::❌❌❌❌❌")
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - func ==================
extension NearMeVC {
    /// 앱 최초 실행 시 사용자에게 받은 위치 권한으로 뷰 구성
    private func configureViewWithInitialLocationStatus() {
        let status = LocationManager.shared.locationManager.authorizationStatus
        setViewWith(status)
    }

    /// 앱 최초 실행 시 사용자에게 받은 위치 권한으로 뷰 구성
    private func setViewWith(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            containerView.removeFromSuperview()
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
            configureMapView()
            setLayout()
        case .notDetermined:
            LocationManager.shared.locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    /// 사용자 위치권한이 허용되어 있지 않을 때 뷰 구성
    private func setRequestPermissionView() {
        requestPermissionView = RequestLocationView(message: "지도")
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

    /// 지도 세팅
    private func configureMapView() {
        mapView = MTMapView(frame: containerView.bounds)
        guard let mapView = mapView else { return }
        let latitude = LocationManager.shared.latitude
        let longitude = LocationManager.shared.longitude

        mapView.delegate = self
        mapView.baseMapType = .standard
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude)), animated: true)
        mapView.setZoomLevel(MTMapZoomLevel(3), animated: true)
        mapView.addCircle(createCurrentLocationRange())

        containerView.addSubview(mapView)
    }

    private func setLayout() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        containerView.addSubview(searchTextField)
        containerView.addSubview(searchButton)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -15),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),

            searchButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            searchButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalToConstant: 60)
        ])

        containerView.addSubview(categoryCollectionView)
        NSLayoutConstraint.activate([
            categoryCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            categoryCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])

        containerView.addSubview(zoomInButton)
        containerView.addSubview(zoomOutButton)
        containerView.addSubview(updateLocationButton)
        NSLayoutConstraint.activate([
            zoomInButton.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 15),
            zoomInButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            zoomInButton.widthAnchor.constraint(equalToConstant: 30),
            zoomInButton.heightAnchor.constraint(equalToConstant: 30),

            zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 15),
            zoomOutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 30),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 30),

            updateLocationButton.topAnchor.constraint(equalTo: zoomOutButton.bottomAnchor, constant: 15),
            updateLocationButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            updateLocationButton.widthAnchor.constraint(equalToConstant: 30),
            updateLocationButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        goToListViewButtonBottomConstraint = goToListViewButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 80)
        containerView.addSubview(goToListViewButton)
        NSLayoutConstraint.activate([
            goToListViewButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            goToListViewButtonBottomConstraint
        ])

        containerView.addSubview(distanceLabel)
        NSLayoutConstraint.activate([
            distanceLabel.centerXAnchor.constraint(equalTo: updateLocationButton.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: updateLocationButton.bottomAnchor, constant: 15),
        ])

        containerView.addSubview(distanceImage)
        NSLayoutConstraint.activate([
            distanceImage.centerXAnchor.constraint(equalTo: distanceLabel.centerXAnchor),
            distanceImage.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
            distanceImage.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    /// CREATE 콜렉션뷰 레이아웃
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return layout
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

    /// 검색 버튼 탭
    @objc func handleSearch() {
        items = []
        mapView?.removeAllPOIItems()

        guard let searchValue = searchTextField.text, !searchValue.isEmpty else { return }
        getSearchedLists(with: searchValue)
    }

    /// 현재 위치로 이동
    @objc func handleUpdateCurrentLocation() {
        mapView?.removeAllCircles()
        LocationManager.shared.isMapLocationUpdateRequest = true
        LocationManager.shared.locationManager.startUpdatingLocation()
        mapView?.addCircle(createCurrentLocationRange())
    }

    /// 줌인 버튼 탭
    @objc func handleZoomIn() {
        switch distance {
        case .TwoAndHalfKilo:
            distance = .OneKilo
            distanceLabel.text = "1km"
            mapView?.setZoomLevel(MTMapZoomLevel(2), animated: true)
        case .FiveKilo:
            distance = .TwoAndHalfKilo
            distanceLabel.text = "2.5km"
            mapView?.setZoomLevel(MTMapZoomLevel(3), animated: true)
        default:
            break
        }
    }

    /// 줌아웃 버튼 탭
    @objc func handleZoomOut() {
        switch distance {
        case .OneKilo:
            distance = .TwoAndHalfKilo
            distanceLabel.text = "2.5km"
            mapView?.setZoomLevel(MTMapZoomLevel(3), animated: true)
        case .TwoAndHalfKilo:
            distance = .FiveKilo
            distanceLabel.text = "5km"
            mapView?.setZoomLevel(MTMapZoomLevel(4), animated: true)
        default:
            break
        }
    }

    /// 현재 위치 생성
    func createCurrentLocationRange() -> MTMapCircle {
        let lat = LocationManager.shared.latitude
        let lon = LocationManager.shared.longitude

        let currentLocation = MTMapPointGeo(latitude: lat, longitude: lon)
        mapView?.setMapCenter(MTMapPoint(geoCoord: currentLocation), animated: true)

        let circle = MTMapCircle()
        circle.circleCenterPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: lat, longitude: lon))
        circle.circleFillColor = .green
        circle.circleLineColor = .primary
        circle.circleLineWidth = 1
        circle.circleRadius = 40
        return circle
    }

    /// 장소 핀 생성
    func createPin(name: String, lat: Double, lon: Double, type: MTMapPOIItemMarkerType) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: lat, longitude: lon))
        item.showAnimationType = .springFromGround
        item.markerType = type
        item.imageNameOfCalloutBalloonRightSide = "AppIcon"
        return item
    }

    /// 검색한 / 선택한 텍스트 리스트 가져오기
    func getSearchedLists(with text: String) {
        let lon = LocationManager.shared.longitude
        let lat = LocationManager.shared.latitude


        DispatchQueue.main.async { [weak self] in
            self?.view.endEditing(true)
        }

        NearMeService.shared.getSearchedPlaces(searchValue: text, lon: lon, lat: lat, distance: distance.rawValue, page: PAGE) { [weak self] placeData in
            self?.placeDatas = placeData?.documents

            self?.placeDatas?.forEach({ place in
                guard let lat = Double(place.y),
                    let lon = Double(place.x),
                    let item = self?.createPin(name: place.placeName, lat: lat, lon: lon, type: .redPin) else { return }
                self?.items.append(item)
            })

            self?.mapView?.addPOIItems(self?.items)

            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    guard let listCount = placeData?.meta.totalCount else { return }
                    if listCount > 0 {
                        self?.goToListViewButton.setTitle("\(listCount)개의 리스트", for: .normal)
                        self?.goToListViewButtonBottomConstraint.constant = -20
                    } else {
                        self?.goToListViewButtonBottomConstraint.constant = 80
                    }
                    self?.containerView.layoutIfNeeded()
                }
            }
        }
    }

    /// 000개 리스트 버튼 탭
    @objc func moveToListView() {
        guard items.count > 0 else { return }
        let listView = NearMeListVC()
        listView.lists = placeDatas
        mapView?.removeAllPOIItems()
        searchTextField.text = ""
        goToListViewButtonBottomConstraint.constant = 80
        navigationController?.pushViewController(listView, animated: true)
    }
}


//MARK: - UICollectionViewDataSource ==================
extension NearMeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return KakaoMapModel.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearMeCategoryCell.identifier, for: indexPath) as? NearMeCategoryCell else { return UICollectionViewCell() }
        let text = KakaoMapModel.allCases[indexPath.item].rawValue
        cell.configure(text: text)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout ==================
extension NearMeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = KakaoMapModel.allCases[indexPath.item].rawValue
        let font = UIFont.systemFont(ofSize: 12)
        let textSize = (text as NSString).size(withAttributes: [.font: font])
        let width = textSize.width + 25
        return CGSize(width: width, height: 35)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchTextField.text = ""
        items = []
        mapView?.removeAllPOIItems()

        let text = KakaoMapModel.allCases[indexPath.item].rawValue
        getSearchedLists(with: text)
    }
}

//MARK: - MTMapViewDelegate ==================
extension NearMeVC: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        mapView.removeAllPOIItems()
        DispatchQueue.main.async { [weak self] in
            self?.view.endEditing(true)

            UIView.animate(withDuration: 0.3) {
                self?.goToListViewButtonBottomConstraint.constant = 80
                self?.containerView.layoutIfNeeded()
            }
        }
    }

    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        guard let placeDatas = placeDatas else { return }
        let index = placeDatas.firstIndex { place in
            return place.placeName == poiItem.itemName
        }
        guard let tappedPlaceIndex = index else { return }
        let placeID = placeDatas[tappedPlaceIndex].id
        CommonUtil.moveToKakaoMap(url: "kakaomap://place?id=\(placeID)", appId: "id304608425")
    }
}


