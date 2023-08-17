//
//  ApiRouter.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/12.
//

import Foundation

enum ApiRouter {
    case weather(query: WeatherQuery, cnt: Int?, city: String?, longitude: Double?, latitude: Double?, requestMethod: String)
    case movie(query: MovieQuery, page: Int, requestMethod: String)
    case moveVideo(movieID: Int, requestMethod: String)
    case genre
    case place(category: String, longitude: Double, latitude: Double, distance: Float)

    // 도메인
    var baseURL: String {
        switch self {
        case .weather(query: _, cnt: _, city: _, longitude: _, latitude: _, requestMethod: _):
            return API.WEATHER_BASE_URL
        case .movie(query: _, page: _, requestMethod: _),
             .moveVideo(movieID: _, requestMethod: _),
             .genre:
            return API.MOVIE_BASE_URL
        case .place(category: _, longitude: _, latitude: _, distance: _):
            return API.MAP_BASE_URL
        }
    }

    // GET | POST | DELETE | PUT
    var method: String {
        switch self {
        case let .weather(query: _, cnt: _, city: _, longitude: _, latitude: _, requestMethod: method):
            return method
        case let .movie(query: _, page: _, requestMethod: method):
            return method
        case let .moveVideo(movieID: _, requestMethod: method):
            return method
        case .genre:
            return "GET"
        case .place(category: _, longitude: _, latitude: _, distance: _):
            return "GET"
        }
    }

    // URL PATH
    var path: String {
        switch self {
        case let .weather(query: query, cnt: _, city: _, longitude: _, latitude: _, requestMethod: _):
            return query == .current ? "data/2.5/weather" : query == .hourly ? "data/2.5/forecast" : "data/2.5/air_pollution"
        case let .movie(query: query, page: _, requestMethod: _):
            return "3/movie/\(query)"
        case let .moveVideo(movieID: movieID, requestMethod: _):
            return "3/movie/\(movieID)/videos"
        case .genre:
            return "3/genre/movie/list"
        case .place(category: _, longitude: _, latitude: _, distance: _):
            return "local/search/keyword.json"
        }
    }

    // URL 쿼리스트링
    var queryString: [String: Any]? {
        guard let movieKey = API.MOVIE_API_KEY else { return nil }
        guard let key = API.WEAHER_API_KEY else { return nil }

        switch self {
        case let .weather(query: _, cnt: count, city: city, longitude: lon, latitude: lat, requestMethod: _):
            if let city = city {
                return ["q": city, "appid": key
                        , "units": "metric"]
            } else if let lat = lat, let lon = lon {
                return ["lat": lat, "lon": lon, "appid": key, "units": "metric"]
            } else if let cnt = count, let lat = lat, let lon = lon {
                return ["lat": lat, "lon": lon, "cnt": cnt, "appid": key, "units": "metric"]
            } else {
                return nil
            }
        case let .movie(query: _, page: page, requestMethod: _):
            return ["api_key": movieKey, "language": "ko", "region": "KR", "page": page]
        case .moveVideo:
            return ["api_key": movieKey, "language": "ko"]
        case .genre:
            return ["api_key": movieKey, "language": "ko"]
        case .place(category: let cate, longitude: let lon, latitude: let lat, distance: let distance):
            return ["y": lat, "x": lon, "query": cate, "radius": distance]
        }
    }

    // POST 요청 BODY : 필요 ❌
    var body: Data? {
        switch self {
        case .weather, .movie, .moveVideo, .genre, .place:
            return nil
        }
    }

    // 개별적으로 필요한 HEADER : 필요 ❌
    var additionalHeaders: [String: String]? {
        guard let kakaoKey = API.MAP_API_KEY else { return nil }
        switch self {
        case .weather, .movie, .moveVideo, .genre:
            return nil
        case .place:
            return ["Authorization": "KakaoAK \(kakaoKey)"]
        }
    }

}


