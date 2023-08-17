//
//  Constants.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import Foundation

final class FirestoreFieldConstant {
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
    case MAP = "K_API_KEY"
}

enum API {
    static let WEATHER_BASE_URL = "https://api.openweathermap.org"
    static let MOVIE_BASE_URL = "https://api.themoviedb.org"
    static let MAP_BASE_URL = "https://dapi.kakao.com/v2"
    static let WEAHER_API_KEY = CommonUtil.getApiKey(for: .Weather)
    static let MOVIE_API_KEY = CommonUtil.getApiKey(for: .Movie)
    static let MAP_API_KEY = CommonUtil.getApiKey(for: .MAP)
}
