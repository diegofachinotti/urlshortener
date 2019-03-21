//
//  ShortenedURLDAO.swift
//  URLShortener
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import Foundation

// TODO: Change to other storage type?
class ShortenedURLDAO {

    static func saveShortenedURLS(_ shortenedURLS:[ShortenedURL]) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(shortenedURLS) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "ShortenedURLS")
        }
        
    }

    static func loadShortenedURLS() -> [ShortenedURL] {
        var savedShortenedURLS:[ShortenedURL] = []
        
        if let shortenedURLData = UserDefaults.standard.object(forKey: "ShortenedURLS") as? Data {
            let decoder = JSONDecoder()
            if let shortenedURLS = try? decoder.decode([ShortenedURL].self, from: shortenedURLData) {
                savedShortenedURLS.append(contentsOf: shortenedURLS)
            }
        }
        
        return savedShortenedURLS
    }

}
