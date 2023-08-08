//
//  UIFont+Ext.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/08.
//

import UIKit

extension UIFont {
    static func Yeonji(size: CGFloat) -> UIFont {
        return UIFont(name: "NanumYeonJiCe", size: size)!
    }
    
    static func Bujang(size: CGFloat) -> UIFont {
        return UIFont(name: "NanumBuJangNimNunCiCe", size: size)!
    }
}
