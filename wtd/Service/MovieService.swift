//
//  MovieService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/28.
//

import Foundation

final class MovieService {
    static let shared = MovieService()
    private init() {}
    let decoder = JSONDecoder()
    let session = URLSessionManager.shared.session
    
    /// 상영중인 영화 API 호출
    func getNowPlayingMovie(page: Int, completion: @escaping (NowPlayingMovieResponse?) -> Void) {
        let urlRequest = URLRequest(router: ApiRouter.movie(query: MovieQuery.now_playing,
                                                            page: page,
                                                            requestMethod: "GET"))
        session?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("❌Error while get now playing movie with \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("❌Error while get now playing movie with invalid response status code")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌Error while get now playing movie")
                completion(nil)
                return
            }
            
            do {
                let nowPlayingData = try self?.decoder.decode(NowPlayingMovieResponse.self, from: data)
                completion(nowPlayingData)
            } catch {
                print("❌Error while get now playing movie with \(error.localizedDescription)")
                completion(nil)
            }
        })
        .resume()
    }
    
    /// 상영 예정인 영화 API 호출
    func getUpcomingMovie(page: Int, completion: @escaping (UpcomingMovieResponse?) -> Void) {
        let urlRequest = URLRequest(router: ApiRouter.movie(query: MovieQuery.upcoming,
                                                            page: page,
                                                            requestMethod: "GET"))
        
        session?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("❌Error while get now playing movie with \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                print("❌Error while get now playing movie with invalid response status code")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌Error while get now playing movie")
                completion(nil)
                return
            }
            
            do {
                let upcomingData = try self?.decoder.decode(UpcomingMovieResponse.self, from: data)
                completion(upcomingData)
            } catch {
                print("❌Error while get now playing movie with \(error)")
                completion(nil)
            }
        })
        .resume()
    }
    
    /// 영화 장르 리스트 API 호출
    func getMovieGenres(completion: @escaping ([Genre]?) -> Void) {
        let urlRequest = URLRequest(router: ApiRouter.genre)
        
        session?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("Error while get movie genres with \(error.localizedDescription) :::::::❌")
                completion(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                print("Error while get movie genres with invalid response status code :::::::❌")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error while get movie genres :::::::❌")
                completion(nil)
                return
            }
            
            do {
                let genreData = try self?.decoder.decode(GenreResponse.self, from: data)
                completion(genreData?.genres)
            } catch {
                print("Error while gen movie genres with \(error) :::::::❌")
                completion(nil)
            }
        })
        .resume()
    }
    
    /// 영화 비디오 URL API 호출
    func getMovieVideoUrl(id: Int, completion: @escaping ([VideoResult]?) -> Void) {
        let urlRequest = URLRequest(router: ApiRouter.moveVideo(movieID: id, requestMethod: "GET"))
        
        session?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("Error while get movie video with \(error.localizedDescription) :::::::❌")
                completion(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                print("Error while get movie video with invalid response status code :::::::❌")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error while get movie video :::::::❌")
                completion(nil)
                return
            }
            
            do {
                let videoData = try self?.decoder.decode(VideoResponse.self, from: data)
                completion(videoData?.results)
            } catch {
                print("Error while gen movie video with \(error) :::::::❌")
                completion(nil)
            }
        })
        .resume()
    }
}
    
