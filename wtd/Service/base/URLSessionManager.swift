//
//  URLSessionManager.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/12.
//  URLSession.shared.dataTask
//  session(config + URLSession).dataTask(with: *URLRequest)

import Foundation

final class URLSessionManager {
    static let shared = URLSessionManager()
    var session: URLSession!
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 40
        config.networkServiceType = .responsiveData
        session = URLSession(configuration: config)
    }
}
