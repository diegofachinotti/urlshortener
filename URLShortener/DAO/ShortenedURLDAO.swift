//
//  ShortenedURLDAO.swift
//  URLShortener
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import Foundation

/// A data access object to retrieve and save ShortenedURLs
class ShortenedURLDAO {

    /// Saves the list of URLs to the storage.
    ///
    /// - Parameter shortenedURLS: The list of ShortenedURLs to save to the storage.
    func saveShortenedURLS(_ shortenedURLS:[ShortenedURL]) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(shortenedURLS) {
            
            // TODO: Change to other storage type?
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "ShortenedURLS")
        }
        
    }

    /// Get's the list of saved URLs
    ///
    /// - Returns: The list of ShortenedURLs saved on the storage.
    func loadShortenedURLS() -> [ShortenedURL] {
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
