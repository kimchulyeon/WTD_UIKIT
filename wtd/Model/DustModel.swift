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
    let components: Component
    let dt: Int
}

// MARK: - Main
struct D_Main: Codable {
    let aqi: Int
}

//MARK: - Component ==================
struct Component: Codable {
    let co: Double
    let no: Double
    let no2: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let nh3: Double

}
