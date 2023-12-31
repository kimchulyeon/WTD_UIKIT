//
//  UserDefaultsService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import Foundation
import FirebaseFirestore

final class UserDefaultsManager {
    //MARK: - properties ==================
    static let shared = UserDefaultsManager()
    private init() { }
}

//MARK: - func ==================
extension UserDefaultsManager {
    /// 로그인 유저 정보 저장
    func saveUserInfo(name: String, email: String, docID: String, uid: String, provider: String, completion: @escaping () -> Void) {
        UserDefaults.standard.set(name, forKey: FirestoreFieldConstant.Name.rawValue)
        UserDefaults.standard.set(email, forKey: FirestoreFieldConstant.Email.rawValue)
        UserDefaults.standard.set(docID, forKey: FirestoreFieldConstant.DocID.rawValue)
        UserDefaults.standard.set(uid, forKey: FirestoreFieldConstant.Uid.rawValue)
        UserDefaults.standard.set(provider, forKey: FirestoreFieldConstant.Provider.rawValue)
        completion()
    }

    /// UserDefaults에서 데이터 가져오기
    func getUserDefaultData(field: FirestoreFieldConstant) -> String? {
        return UserDefaults.standard.string(forKey: field.rawValue)
    }

    /// 게스트인지
    func isGuest() -> Bool {
        return UserDefaultsManager.shared.getUserDefaultData(field: .Name) == nil
    }

    /// UserDefaults 비우기 (로그아웃)
    func resetUserDefaults(completion: @escaping () -> Void) {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            completion()
        }
    }
}
