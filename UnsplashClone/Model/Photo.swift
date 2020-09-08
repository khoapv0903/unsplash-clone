//
//  Photo.swift
//  UnsplashClone
//
//  Created by Khoa Pham on 9/7/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import Foundation

struct Urls {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

extension Urls: Decodable {
    
    private enum UrlsCodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UrlsCodingKeys.self)
        
        raw = try container.decode(String.self, forKey: .raw)
        full = try container.decode(String.self, forKey: .full)
        regular = try container.decode(String.self, forKey: .regular)
        small = try container.decode(String.self, forKey: .small)
        thumb = try container.decode(String.self, forKey: .thumb)
    }
}

struct Photo {
    let id: String
    let urls: Urls
}

extension Photo: Decodable {
    
    private enum PhotoCodingKeys: String, CodingKey {
        case id
        case urls
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PhotoCodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        urls = try container.decode(Urls.self, forKey: .urls)
    }
}
