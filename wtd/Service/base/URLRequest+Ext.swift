//
//  URLRequest+Ext.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/12.
//

import Foundation

extension URLRequest {
    // 사용자 지정 초기화
    init(router: ApiRouter) {
        let base_url = URL(string: router.baseURL)!
        var full_url = base_url.appendingPathComponent(router.path)

        // URLRequest(url: )를 초기화
        self.init(url: full_url)

        // GET | POST | DELETE | PUT
        self.httpMethod = router.method

        // HEADER 세팅
        if let headers = router.additionalHeaders {
            for (key, value) in headers {
                self.setValue(value, forHTTPHeaderField: key)
            }
        }

        // 쿼리스트링 세팅
        if let queryStrings = router.queryString {
            if var components = URLComponents(string: full_url.absoluteString) {
                components.queryItems = queryStrings.map { qs in
                    URLQueryItem(name: qs.key, value: "\(qs.value)")
                }
                
                if let urlWithQS = components.url {
                    full_url = urlWithQS
                    self.url = full_url
                }
            }
        }
    }
}
