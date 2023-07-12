//
//  UserDefaultsService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import Foundation
import FirebaseFirestore

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() { }

    /// 로그인 유저 정보 저장
    func saveUserInfo(name: String, email: String, docID: String, uid: String, completion: @escaping () -> Void) {
        UserDefaults.standard.set(name, forKey: FirestoreFieldConstant.Name)
        UserDefaults.standard.set(email, forKey: FirestoreFieldConstant.Email)
        UserDefaults.standard.set(docID, forKey: FirestoreFieldConstant.DocID)
        UserDefaults.standard.set(uid, forKey: FirestoreFieldConstant.Uid)

        completion()
    }
	
	/// 사용자의 위치 (도시명) 저장 - 불필요한 api호출 바잊
	func saveUserCity(city: String) {
		print("USERDEFAULTS에 유저 도시 저장 \(city)")
		UserDefaults.standard.set(city, forKey: "lastCity")
	}
}
