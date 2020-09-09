//
//  ImageDownloader.swift
//  UnsplashClone
//
//  Created by Khoa Pham on 9/7/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

final class ImageDownloader: NSObject, URLSessionDataDelegate {
    
    static let shared = ImageDownloader()
        
    private let cache: ImageCacheType
        
    init(cache: ImageCacheType = ImageCache.shared) {
        self.cache = cache
    }
    
    func startLoad(withUrl imageUrl: String, completion: @escaping (_ cachedImage: UIImage?, _ downloadedImage: UIImage?) -> ()) {
        
        let url = URL(string: imageUrl)!
        
        if let cachedImage = cache[url] {
            completion(cachedImage, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Something went wrong")
                return
            }
            if let data = data, let downloadedImage = UIImage(data: data) {
                self.cache[url] = downloadedImage
                DispatchQueue.main.async {
                    completion(nil, downloadedImage)
                }
            }
        }
        
        task.resume()
    }
}
