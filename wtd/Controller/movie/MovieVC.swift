//
//  MovieVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import UIKit

class MovieVC: UIViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MOVIE VC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("MOVIE VC VIEW WILL APPEAR")
    }
}
