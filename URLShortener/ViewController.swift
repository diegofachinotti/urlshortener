//
//  ViewController.swift
//  URLShortener
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import UIKit

// TODO: Move to own file.
class ShortenedURL {
    var date:Date
    var originalURL:URL
    var shortURL:URL
    
    init(date:Date, originalURL:URL, shortURL:URL){
        self.date = date
        self.originalURL = originalURL
        self.shortURL = shortURL
    }
}


// TODO: Move to own file.
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


class ViewController: UIViewController {

    var shortenedURLS:[ShortenedURL] = []
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var shortenedURLSTableView: UITableView!
    
    @IBAction func shortenTouched(_ sender: Any) {
        
        guard let urlString = urlField.text else {
            // No text in the field. Let's not continue.
            return
        }
        
        guard let originalURL = URL(string: urlString) else {
            // The URL contains illegal characters or is empty. Let's not continue.
            return
        }
        
        TinyURLAPI.tinify(url: originalURL, completion: { (shortURL:URL?) -> Void in
            
            if let shortURL = shortURL {
                
                let shortenedURL = ShortenedURL(date: Date(), originalURL: originalURL, shortURL: shortURL)
                self.shortenedURLS.append(shortenedURL)
                
                DispatchQueue.main.async {
                    self.shortenedURLSTableView.reloadData()
                    self.urlField.resignFirstResponder()
                }
                
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup as the data source
        shortenedURLSTableView.dataSource = self
        shortenedURLSTableView.delegate = self
    }

}


extension ViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shortenedURLS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shortendURL = shortenedURLS[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShortURLTableViewCell") as? ShortURLTableViewCell else {
            // This shouldn't happen as we have set the identifier in the storyboard. But if it does it won't crash, the row will be empty.
            return ShortURLTableViewCell()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        cell.dateLabel.text = formatter.string(from: shortendURL.date)
        cell.originalURLLabel.text = shortendURL.originalURL.absoluteString
        cell.shortURLLabel.text = shortendURL.shortURL.absoluteString
        
        return cell
    }
    
}


extension ViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shortendURL = shortenedURLS[indexPath.row]
        
        if UIApplication.shared.canOpenURL(shortendURL.shortURL) {
            
            // Open the Tiny URL in the browser when selecting the cell.
            UIApplication.shared.open(shortendURL.shortURL, options: [:], completionHandler: nil)
        }
    }
    
}


class ShortURLTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var originalURLLabel: UILabel!
    @IBOutlet weak var shortURLLabel: UILabel!
}
