//
//  NearMeVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class NearMeVC: UIViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print("NEAR ME VC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("NEARME VC VIEW WILL APPEAR")
    }
}
