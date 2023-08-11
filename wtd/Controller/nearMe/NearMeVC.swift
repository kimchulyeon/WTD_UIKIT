//
//  NearMeVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class NearMeVC: UIViewController {
    //MARK: - properties ==================
    var mapView: MTMapView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        CommonUtil.configureBasicView(for: self)
        configureMapView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
}

extension NearMeVC {
    private func configureMapView() {
        mapView = MTMapView(frame: view.bounds)
        guard let mapView = mapView else { return }
        mapView.delegate = self
        mapView.baseMapType = .standard
        view.addSubview(mapView)
    }
}

extension NearMeVC: MTMapViewDelegate {
    
}
