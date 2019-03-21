//
//  ShortenedURL.swift
//  URLShortener
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import Foundation


/// Class containing the information we need to store to display the list of URL we shortenned using the Tiny URL API.
class ShortenedURL:Codable {
    var date:Date
    var originalURL:URL
    var shortURL:URL
    
    /// Initialiser
    ///
    /// - Parameters:
    ///   - date: The creation date
    ///   - originalURL: The full original URL before tinyfication
    ///   - shortURL: The resulting Tiny URL
    init(date:Date, originalURL:URL, shortURL:URL){
        self.date = date
        self.originalURL = originalURL
        self.shortURL = shortURL
    }
}
