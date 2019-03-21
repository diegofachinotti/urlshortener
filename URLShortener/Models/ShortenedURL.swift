//
//  ShortenedURL.swift
//  URLShortener
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import Foundation


class ShortenedURL:Codable {
    var date:Date
    var originalURL:URL
    var shortURL:URL
    
    init(date:Date, originalURL:URL, shortURL:URL){
        self.date = date
        self.originalURL = originalURL
        self.shortURL = shortURL
    }
}
