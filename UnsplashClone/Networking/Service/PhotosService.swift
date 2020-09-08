//
//  PhotosService.swift
//  UnsplashClone
//
//  Created by Khoa Pham on 9/7/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import Foundation

final class PhotosService {
    deinit {
        print("PhotosService is being deinitialized")
    }
    
    private let client = APIClient()
    
    @discardableResult
    func listPhotos(completion: @escaping ([Photo]?, ServiceError?) -> ()) -> URLSessionDataTask? {

        let params: JSON = ["page": 3, "per_page": 30]

        return client.load(path: "/photos", method: .get, params: params) { (result, error) in
            if let error = error {
                completion(nil, ServiceError.custom(error.localizedDescription))
            } else if let jsonData = result {
                do {
                    let apiResponse = try JSONDecoder().decode([Photo].self, from: jsonData)
                    completion(apiResponse, nil)
                } catch let error {
                    print(error)
                    completion(nil, ServiceError.custom(error.localizedDescription))
                }
            }
        }
    }
}
