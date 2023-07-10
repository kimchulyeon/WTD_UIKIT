//
//  Constants.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import Foundation

class FirestoreFieldConstant {
    private init() {}
    static let Name = "name"
    static let Email = "email"
    static let DocID = "docID"
    static let Uid = "uid"
    static let CreatedAt = "createdAt"
}

enum ApiKeyNameConstant: String {
    case Weather = "W_API_KEY"
    case Movie = "M_API_KEY"
}

enum ApiUrlConstant: String {
    case Weather = "http://api.openweathermap.org/data/2.5"
    case Movie = "http://api.themoviedb.org/3/movie"
}
