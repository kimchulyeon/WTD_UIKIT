//
//  FirebaseService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/05.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

let DB = Firestore.firestore()

final class FirebaseService {
    static let shared = FirebaseService()
    private init() { }

    let USER_COL = DB.collection("users")

    /// 파이어베이스 로그인 + 기존/신규 유저 체크
    func loginFirebase(credential: AuthCredential, completion: @escaping (_ uid: String?, _ isNewUser: Bool, _ docID: String?) -> Void) {
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let error = error {
                print("Error \(error.localizedDescription) :::::::: ❌")
                completion(nil, true, nil)
                return
            }
            guard let uid = result?.user.uid else {
                print("Error There is no UID while signing in Apple :::::::: ❌")
                completion(nil, true, nil)
                return
            }

            self?.checkAlreadySignedIn(with: uid) { docID in
                if let docID = docID {
                    // 기존 유저
                    completion(uid, false, docID)
                } else {
                    // 신규 유저
                    completion(uid, true, nil)
                }
            }
        }
    }

    /// 기존에 가입한 유저인지 판별
    private func checkAlreadySignedIn(with uid: String, completion: @escaping (_ docID: String?) -> Void) {
        USER_COL.whereField(FirestoreFieldConstant.Uid.rawValue, isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print("Error \(error.localizedDescription) :::::::: ❌")
                completion(nil)
                return
            }
            if let snapshot = snapshot,
                let document = snapshot.documents.first {

                completion(document.documentID)
                return
            } else {
                completion(nil)
                return
            }
        }
    }

    /// 이름 | 이메일 | uid | createdAt 데이터베이스에 저장
    func saveUserInDatabase(name: String, email: String, uid: String, completion: @escaping (_ docID: String) -> Void) {
        let DOC = USER_COL.document()
        let DOC_ID = DOC.documentID

        let data: [String: Any] = [
            FirestoreFieldConstant.Name.rawValue: name,
            FirestoreFieldConstant.Email.rawValue: email,
            FirestoreFieldConstant.Uid.rawValue: uid,
            FirestoreFieldConstant.DocID.rawValue: DOC_ID,
            FirestoreFieldConstant.CreatedAt.rawValue: FieldValue.serverTimestamp()
        ]
        DOC.setData(data) { error in
            if let error = error {
                print("Error \(error.localizedDescription) :::::::: ❌")
                return
            }
            completion(DOC_ID)
        }
    }


    /// docID로 가입된 유저 정보 가져오기
    func getUserInfo(with docID: String, completion: @escaping (_ name: String,
                                                                _ email: String,
                                                                _ uid: String,
                                                                _ docID: String) -> Void) {
        USER_COL.document(docID).getDocument { snapshot, error in
            if let error = error {
                print("Error \(error.localizedDescription) :::::::: ❌")
                return
            }

            if let snapshot = snapshot,
                let name = snapshot.get(FirestoreFieldConstant.Name.rawValue) as? String,
                let email = snapshot.get(FirestoreFieldConstant.Email.rawValue) as? String,
                let uid = snapshot.get(FirestoreFieldConstant.Uid.rawValue) as? String,
                let docID = snapshot.get(FirestoreFieldConstant.DocID.rawValue) as? String {

                completion(name, email, uid, docID)
            }
        }
    }

    /// 닉네임 변경
    func changeNicknameInDatabase(with docID: String, newValue: String, completion: @escaping (_ success: Bool) -> Void) {
        USER_COL.document(docID).updateData([
            FirestoreFieldConstant.Name.rawValue: newValue
        ]) { error in
            if let error = error {
                print("Error while changing nickname with \(error) :::::::❌")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
