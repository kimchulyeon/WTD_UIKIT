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
	func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
		let fullImagePath = "https://image.tmdb.org/t/p/w500\(urlString)"
		let cacheKey = NSString(string: fullImagePath)

		if let cachedImage = imageCache.object(forKey: cacheKey) {
			completion(cachedImage)
			return
		}

		guard let url = URL(string: fullImagePath) else {
			completion(nil)
			return
		}

		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			if let error = error {
				print("Error while load image with \(error) :::::::: ❌")
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
	}
}

