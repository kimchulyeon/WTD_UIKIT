//
//  ProfileVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PROFILE VC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("PROFILE VC VIEW WILL APPEAR")
    }
}
