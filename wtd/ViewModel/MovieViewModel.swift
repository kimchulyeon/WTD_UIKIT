//
//  MovieViewModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/28.
//

import Foundation

final class MovieViewModel: NSObject {
    //MARK: - properties ==================
    var nowPlayingResponse: MovieResponse? = nil
    var upcomingResponse: MovieResponse? = nil
    var nowPlayingMovieList: [Result]? = nil
    var upcomingMovieList: [Result]? = nil
    var genreList: [Genre] = []
    var nowPage = 1
    var upcomingPage = 1

    //MARK: - lifecycle ==================
    override init() {
        super.init()

        fetchMovieDatas()
    }

    //MARK: - func ==================

    /// 상영중인 영화 호출
    func getNowMovie(page: Int, completion: @escaping () -> Void) {
        MovieService.shared.getNowPlayingMovie(page: page) { [weak self] data in
            guard let results = data?.results else { return }
            self?.nowPlayingResponse = data
            self?.nowPlayingMovieList = results
            completion()
        }
    }

    /// 상영 예정 영화 호출
    func getUpcomingMovie(page: Int, completion: @escaping () -> Void) {
        MovieService.shared.getUpcomingMovie(page: page) { [weak self] data in
            guard let results = data?.results else { return }
            self?.upcomingResponse = data
            self?.upcomingMovieList = results
            completion()
        }
    }

    /// 장르 리스트 호출
    fileprivate func getGenreList(completion: @escaping () -> Void) {
        MovieService.shared.getMovieGenres { [weak self] data in
            guard let data = data else { return }
            self?.genreList = data
            completion()
        }
    }

    /// 뷰모델 인스턴스 생성 시 영화 API 호출
    func fetchMovieDatas() {
        let group = DispatchGroup()

        group.enter()
        getNowMovie(page: nowPage) {
            group.leave()
        }
        group.enter()
        getUpcomingMovie(page: upcomingPage) {
            group.leave()
        }

        group.enter()
        getGenreList() {
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let _ = self else { return }
        }
    }
}
