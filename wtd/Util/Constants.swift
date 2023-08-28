//
//  Constants.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/06.
//

import Foundation

enum UserLoginType {
    case google
    case apple
    case guest
}

enum ProviderType: String {
    case google = "google"
    case apple = "apple"
}

/// 파이어베이스 데이터베이스 필드명
enum FirestoreFieldConstant: String {
    case Name = "name"
    case Email = "email"
    case DocID = "docID"
    case Uid = "uid"
    case CreatedAt = "createdAt"
    case Provider = "provider"
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

/// 약관 URL
struct TermsUrl {
    static let privacy = "https://carbonated-stoplight-4f5.notion.site/85bd513e10f240c5a234c8267424943e?pvs=4"
    static let service = "https://carbonated-stoplight-4f5.notion.site/2772556062e04db29fb21ebfc1245c29?pvs=4"
    static let location = "https://carbonated-stoplight-4f5.notion.site/b6e9ef7bf65d4d688c9c4b16ad42670d?pvs=4"
}

/// 프로필 탭 버튼 타이틀
enum ProfileButtonTitle: String {
    case license = "라이센스"
    case support = "문의하기"
    case login = "로그인하러가기"
    case logout = "로그아웃"
    case leave = "회원탈퇴"
}
