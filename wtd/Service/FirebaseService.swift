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

class FirebaseService {
	static let shared = FirebaseService()
	private init() { }

	let USER_COL = DB.collection("users")

	/// 파이어베이스 로그인
	func loginFirebase(credential: AuthCredential, completion: @escaping (_ uid: String?, _ isNewUser: Bool, _ docID: String?) -> Void) {
		Auth.auth().signIn(with: credential) { result, error in
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

			FirebaseService.shared.checkAlreadySignedIn(with: uid) { docID in
				if docID != nil {
					// 기존 유저
					print("이미 가입한 유저입니다 🥺 \(docID)")
					completion(uid, false, docID)
				} else {
					// 신규 유저
					print("신규 유저::::::::")
					completion(uid, true, nil)
				}
			}
		}
	}

	/// 이름 | 이메일 | uid | createdAt 데이터베이스에 저장
	func saveUserInDatabase(name: String, email: String, uid: String, completion: @escaping () -> Void) {
		let DOC = USER_COL.document()
		let DOC_ID = USER_COL.document().documentID
		
		print("DOC ID 저장 : \(DOC_ID)")

		let data: [String: Any] = [
			"name": name,
			"email": email,
			"uid": uid,
			"docID": DOC_ID,
			"createdAt": FieldValue.serverTimestamp()
		]
		DOC.setData(data) { error in
			if let error = error {
				print("Error \(error.localizedDescription) :::::::: ❌")
				return
			}
			completion()
		}
	}

	/// 기존에 가입한 유저인지 판별
	func checkAlreadySignedIn(with uid: String, completion: @escaping (_ docID: String?) -> Void) {
		USER_COL.whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
			if let error = error {
				print("Error \(error.localizedDescription) :::::::: ❌")
				completion(nil)
				return
			}
			if let snapshot = snapshot,
				let document = snapshot.documents.first {

				print("가입된 유저:::::")
				completion(document.documentID)
				return
			} else {
				print("신규 유저:::::")
				completion(nil)
				return
			}
		}
	}

	// docID로 가입된 유저 정보 가져오기
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
				let name = snapshot.get("name") as? String,
				let email = snapshot.get("email") as? String,
				let uid = snapshot.get("uid") as? String,
				let docID = snapshot.get("docID") as? String {

				completion(name, email, uid, docID)
			}
		}
	}
}
