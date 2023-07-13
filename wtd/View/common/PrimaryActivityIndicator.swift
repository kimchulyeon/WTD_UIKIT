//
//  PrimaryActivityIndicator.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/13.
//

import Foundation

import UIKit

class PrimaryActivityIndicator: UIActivityIndicatorView {
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        
        setView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.color = UIColor.primary
        self.hidesWhenStopped = true
    }
}

