//
//  TinyURLAPI.swift
//  URLShortener
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import UIKit


/// Class containing static methods to access tinyurl's API.
class TinyURLAPI {
    
    private static let tinyurlAPIEndpoint = "http://tinyurl.com/api-create.php?url="
    
    
    /// Allows to tinify a valid URL using the tinyurl API.
    ///
    /// - Parameters:
    ///   - url: The URL to tinify
    ///   - completion: Returns the tinified URL if sucessful. If anything is wrong returns nil.
    static func tinify(url:URL, completion: @escaping (URL?) -> Void) {
        
        if !UIApplication.shared.canOpenURL(url) {
            // The URL cannot be opened. Let's not continue.
            completion(nil)
            return
        }
        
        let tinyurlAPI = tinyurlAPIEndpoint + url.absoluteString
        
        guard let tinyurl = URL(string: tinyurlAPI) else {
            // Again the URL contains illegal characters or is empty. This shouldn't happen but let's not continue.
            completion(nil)
            return
        }
        
        let request = URLRequest(url: tinyurl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error:Error?) -> Void in
            
            if error != nil {
                // The URL is probably not valid. Let's not continue.
                completion(nil)
                return
            }
            
            guard let data = data else {
                // No data. Let's not continue.
                completion(nil)
                return
            }
            
            if let content = String(data: data, encoding: .ascii) {
                
                guard let shortURL = URL(string: content) else {
                    // The URL contains illegal characters or is empty. Let's not continue.
                    completion(nil)
                    return
                }
                
                completion(shortURL)
                return
            }
            
            completion(nil)
            return
        })
        
        task.resume()
    }
}
