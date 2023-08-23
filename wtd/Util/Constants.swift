//
//  Constants.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import Foundation

/// 파이어베이스 데이터베이스 필드명
enum FirestoreFieldConstant: String {
    case Name = "name"
    case Email = "email"
    case DocID = "docID"
    case Uid = "uid"
    case CreatedAt = "createdAt"
}

/// API KEY 변수
enum ApiKeyNameConstant: String {
    case Weather = "W_API_KEY"
    case Movie = "M_API_KEY"
    case MAP = "K_API_KEY"
}

/// API 관련 상수 (API주소 / API키)
enum API {
    static let WEATHER_BASE_URL = "https://api.openweathermap.org"
    static let MOVIE_BASE_URL = "https://api.themoviedb.org"
    static let MAP_BASE_URL = "https://dapi.kakao.com/v2"
    static let WEAHER_API_KEY = CommonUtil.getApiKey(for: .Weather)
    static let MOVIE_API_KEY = CommonUtil.getApiKey(for: .Movie)
    static let MAP_API_KEY = CommonUtil.getApiKey(for: .MAP)
}

