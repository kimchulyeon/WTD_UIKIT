//
//  UserDefaultsService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import Foundation
import FirebaseFirestore

class UserDefaultsService {
    static let shared = UserDefaultsService()
    private init() {}
    
    func saveUserInfo(name: String, email: String, docID: String, uid: String, completion: @escaping () -> Void) {
        UserDefaults.standard.set(name, forKey: FirestoreFieldConstant.Name)
        UserDefaults.standard.set(email, forKey: FirestoreFieldConstant.Email)
        UserDefaults.standard.set(docID, forKey: FirestoreFieldConstant.DocID)
        UserDefaults.standard.set(uid, forKey: FirestoreFieldConstant.Uid)
        
        completion()
    }
}
