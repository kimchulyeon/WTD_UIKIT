//
//  DustModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/13.
//

import Foundation

/// 미세 먼지 =======================================
// MARK: - DustResponse
struct DustResponse: Codable {
    let coord: D_Coord
    let list: [List]
}

// MARK: - Coord
struct D_Coord: Codable {
    let lon, lat: Double
}

// MARK: - List
struct List: Codable {
    let main: D_Main
    let components: [String: Double]
    let dt: Int
}

// MARK: - Main
struct D_Main: Codable {
    let aqi: Int
}
