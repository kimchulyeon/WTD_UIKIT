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
    var nowPlayingMovieList: [Result] = []
    var upcomingMovieList: [Result] = []
    var genreList: [Genre] = []
    var nowPage = 1
    var upcomingPage = 1
    var isLoading = false
    var TOTAL_PAGE = 2

    //MARK: - lifecycle ==================
    override init() {
        super.init()

        fetchMovieDatas()
    }

    //MARK: - func ==================
    /// 뷰모델 인스턴스 생성 시 영화 API 호출
    func fetchMovieDatas() {
        let group = DispatchGroup()
        isLoading = true

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
            self?.isLoading = false
        }
    }

    /// 상영중인 영화 호출
    func getNowMovie(page: Int, completion: @escaping () -> Void) {
        MovieService.shared.getNowPlayingMovie(page: page) { [weak self] data in
            guard let results = data?.results else { return }
            self?.nowPlayingResponse = data
            self?.nowPlayingMovieList.append(contentsOf: results)

            if (data?.totalPages ?? 0) < 2 {
                self?.TOTAL_PAGE = 1
            } else {
                self?.nowPage += 1
            }
            completion()
        }
    }

    /// 상영 예정 영화 호출
    func getUpcomingMovie(page: Int, completion: @escaping () -> Void) {
        MovieService.shared.getUpcomingMovie(page: page) { [weak self] data in
            guard let results = data?.results else { return }
            self?.upcomingResponse = data
            self?.upcomingMovieList.append(contentsOf: results)
            if (data?.totalPages ?? 0) < 2 {
                self?.TOTAL_PAGE = 1
            } else {
                self?.upcomingPage += 1
            }
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
    
    /// 상영중인 영화 더보기
    func loadMoreNowPlaying(completion: @escaping () -> Void) {
        print("페이지네이션 실행:::::::::::::")
        guard !isLoading, nowPage <= TOTAL_PAGE else { return }
        isLoading = true
        getNowMovie(page: nowPage) { [weak self] in
            self?.isLoading = false
            completion()
        }
    }
    
    /// 상영예정인 영화 더보기
    func loadMoreUpcoming(completion: @escaping () -> Void) {
        guard !isLoading, upcomingPage <= TOTAL_PAGE else { return }
        isLoading = true
        getUpcomingMovie(page: upcomingPage) { [weak self] in
            self?.isLoading = false
            completion()
        }
    }
}
