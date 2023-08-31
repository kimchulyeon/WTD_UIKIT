//
//  MovieModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/28.
//

import Foundation

// MARK: - NowPlayingMovieResponse
struct MovieResponse: Codable {
    let dates: Dates
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable {
    let maximum, minimum: String
}

struct Result: Codable, Hashable {
    let identifier = UUID()
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

//MARK: - GenreResponse ==================
struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}

//MARK: - Video ==================
struct VideoResponse: Codable {
    let id: Int
    let results: [VideoResult]
}

// MARK: - Result
struct VideoResult: Codable {
    let iso639_1, iso3166_1, name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

//MARK: - API URL PATH (collectionView Section) ==================
enum MovieQuery: String, Hashable {
    case now_playing = "상영중인 영화"
    case upcoming = "상영예정인 영화"
}

enum MovieItem: Hashable {
    case oneItemCell(Result)
    case twoItemCell(Result)
}
