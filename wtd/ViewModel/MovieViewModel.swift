//
//  MovieViewModel.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/28.
//

import Foundation

final class MovieViewModel: NSObject {
    //MARK: - properties ==================
    var nowPlayingList: NowPlayingMovieResponse? = nil
    var upcomingList: UpcomingMovieResponse? = nil
    
    //MARK: - lifecycle ==================
    override init() {
        super.init()
        
        fetchMovieDatas()
    }
    
    //MARK: - func ==================
    
    /// 상영중인 영화 호출
    fileprivate func getNowMovie(completion: @escaping () -> Void) {
        MovieService.shared.getNowPlayingMovie(page: 1) { [weak self] data in
            self?.nowPlayingList = data
            completion()
        }
    }
    
    /// 상영 예정 영화 호출
    fileprivate func getUpcomingMovie(completion: @escaping () -> Void) {
        MovieService.shared.getUpcomingMovie(page: 1) { [weak self] data in
            self?.upcomingList = data
            completion()
        }
    }
    
    /// 뷰모델 인스턴스 생성 시 영화 API 호출
    func fetchMovieDatas() {
        let group = DispatchGroup()
        
        group.enter()
        getNowMovie() {
            group.leave()
        }
        group.enter()
        getUpcomingMovie() {
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
//            print("FETCH 완료:::::::::::::: \n \(self?.nowPlayingList) \n \n \(self?.upcomingList)")
        }
    }
}
