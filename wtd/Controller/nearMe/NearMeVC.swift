//
//  NearMeVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class NearMeVC: UIViewController {
    //MARK: - properties ==================
    private var mapView: MTMapView?
    private let meter = 2000

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

    private let searchButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("검색", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tintColor = .white
        btn.backgroundColor = .secondary
        btn.layer.cornerRadius = 5
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4.0
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
    
    private let updateLocationButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "scope"), for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .secondary
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4.0
        return btn
    }()
    private let zoomInButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .secondary
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4.0
        return btn
    }()
    private let zoomOutButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "minus.magnifyingglass"), for: .normal)
        btn.backgroundColor = .white
        btn.tintColor = .secondary
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 4.0
        return btn
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        CommonUtil.configureBasicView(for: self)
        CommonUtil.configureNavBar(for: self)
        configureMapView()
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.isHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension NearMeVC {
    private func configureMapView() {
        mapView = MTMapView(frame: view.bounds)
        guard let mapView = mapView else { return }
        let latitude = LocationManager.shared.latitude
        let longitude = LocationManager.shared.longitude
        
        mapView.baseMapType = .standard
        mapView.isUserInteractionEnabled = false
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude)), animated: true)
        mapView.setZoomLevel(MTMapZoomLevel(3), animated: true)
        mapView.currentLocationTrackingMode = .onWithoutHeading

        view.addSubview(mapView)
    }

    private func setLayout() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -15),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),

            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(categoryCollectionView)
        NSLayoutConstraint.activate([
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(updateLocationButton)
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        NSLayoutConstraint.activate([
            updateLocationButton.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 15),
            updateLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            updateLocationButton.widthAnchor.constraint(equalToConstant: 30),
            updateLocationButton.heightAnchor.constraint(equalToConstant: 30),
            
            zoomInButton.topAnchor.constraint(equalTo: updateLocationButton.bottomAnchor, constant: 15),
            zoomInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            zoomInButton.widthAnchor.constraint(equalToConstant: 30),
            zoomInButton.heightAnchor.constraint(equalToConstant: 30),
            
            zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 15),
            zoomOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 30),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return layout
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
}
