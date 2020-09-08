//
//  ImageDownloader.swift
//  UnsplashClone
//
//  Created by Khoa Pham on 9/7/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

final class ImageDownloader: NSObject, URLSessionDataDelegate {
    
//    private lazy var session: URLSession = {
//        let configuration = URLSessionConfiguration.default
//        configuration.waitsForConnectivity = true
//        return URLSession(configuration: configuration,
//                          delegate: self, delegateQueue: nil)
//    }()
//
    static let shared = ImageDownloader()
    
    private var task: URLSessionDataTask?
    
    private let cache: ImageCacheType
    
//    weak var cell: PhotoCell?
    
    init(cache: ImageCacheType = ImageCache.shared) {
        self.cache = cache
    }

//    var receivedData: Data?
    
    func startLoad(withUrl imageUrl: String, completion: @escaping (_ cachedImage: UIImage?, _ downloadedImage: UIImage?) -> ()) {
//        guard let imageUrl = cell?.imageUrl else { return }
        
        let url = URL(string: imageUrl)!
        
        if let cachedImage = cache[url] {
//            cell?.showCachedImage(cachedImage)
            completion(cachedImage, nil)
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
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
//                    self.cell?.showImage(downloadedImage)
                    completion(nil, downloadedImage)
                }
            }
        }
        task?.resume()
        print("Task identifier: \(task?.taskIdentifier ?? -999)")
    }
    
    func cancel() {
        guard task != nil else { return }
        task!.cancel()
        task = nil
    }
    
//     func startLoad() {
//        guard let imageUrl = cell?.imageUrl else { return }
//        if let task = task {
//            task.cancel()
//        }
//        let url = URL(string: imageUrl)!
//        receivedData = Data()
//        let downloadTimeout: TimeInterval = 15.0
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: downloadTimeout)
//        task = session.dataTask(with: request)
//        task?.resume()
//     }
//
//    // delegate methods
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
//                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//        guard let response = response as? HTTPURLResponse,
//            (200...299).contains(response.statusCode) else {
//            completionHandler(.cancel)
//            return
//        }
//        completionHandler(.allow)
//    }
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        self.receivedData?.append(data)
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        DispatchQueue.main.async {
//            if let error = error {
//                print(error)
//            } else if let receivedData = self.receivedData,
//                let downloadedImage = UIImage(data: receivedData) {
//                if let originalUrl = task.originalRequest?.url?.absoluteString, originalUrl == self.cell?.imageUrl {
//                    self.cell?.setImage(downloadedImage)
//                }
//            }
//        }
//    }
}
