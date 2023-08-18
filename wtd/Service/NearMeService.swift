//
//  NearMeService.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/17.
//

import Foundation

final class NearMeService {
    static let shared = NearMeService()
    private init() { }
    
    let decoder = JSONDecoder()
    let session = URLSessionManager.shared.session
    
    /// 검색어로 장소 데이터 가져오기
    func getSearchedPlaces(searchValue: String, lon: Double, lat: Double, distance: Float, completion: @escaping (PlaceResponse?) -> Void) {
        let urlRequest = URLRequest(router: ApiRouter.place(category: searchValue, longitude: lon, latitude: lat, distance: distance))
        session?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("❌Error while get places with \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("❌Error while get places with invalid response")
                completion(nil)
                return
            }

            guard (200...299).contains(response.statusCode) else {
                print("❌Error while get places with invalid status code")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌Error while get places with invalid data")
                completion(nil)
                return
            }

            
            do {
                let placeData = try self?.decoder.decode(PlaceResponse.self, from: data)
                completion(placeData)
            } catch {
                print("❌Error while get places with \(error.localizedDescription)")
                completion(nil)
            }
        })
        .resume()
    }
}
