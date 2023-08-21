//
//  ImageManager.swift
//  wtd
//
//  Created by chulyeon kim on 2023/07/29.
//

import UIKit

class ImageManager {
	static let shared = ImageManager()
	private let imageCache = NSCache<NSString, UIImage>()
	private init() { }
}

//MARK: - func ==============================
extension ImageManager {
    @discardableResult
	func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
		let fullImagePath = "https://image.tmdb.org/t/p/w500\(urlString)"
		let cacheKey = NSString(string: fullImagePath)

		if let cachedImage = imageCache.object(forKey: cacheKey) {
			completion(cachedImage)
			return nil
		}

		guard let url = URL(string: fullImagePath) else {
			completion(nil)
			return nil
		}

		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			if let _ = error {
                completion(nil)
				return
			}
			guard let data = data, let image = UIImage(data: data) else {
				completion(nil)
				return
			}

			self?.imageCache.setObject(image, forKey: cacheKey)

			DispatchQueue.main.async {
				completion(image)
			}
		}

        task.resume()
		return task
	}
}

