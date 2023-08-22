//
//  NearMeModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/17.
//

import Foundation

enum KakaoMapModel: String, CaseIterable {
    case restaurant = "음식점"
    case cafe = "카페"
    case soju = "술집"
    case movie = "영화관"
    case pc = "PC방"
    case sing = "노래방"
    case stay = "숙박"
    case massage = "마사지"
    case mart = "마트"
    case culture = "문화시설"
}


enum Distance: Float {
    case OneKilo = 500
    case TwoAndHalfKilo = 1250
    case FiveKilo = 2500
}

/// PlaceResponse
struct PlaceResponse: Codable {
    let documents: [Document]
    let meta: Meta
}

// MARK: - Document
struct Document: Codable {
    let addressName, categoryGroupCode, categoryGroupName, categoryName: String
    let distance, id, placeName: String
    let phone, placeURL: String?
    let roadAddressName, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
