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
    static func tinify(url:URL) -> URL {
        
        // TODO: Really implement
        return url
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
        
        if !UIApplication.shared.canOpenURL(originalURL) {
            // The URL cannot be opened. Let's not continue.
            return
        }
        
        let shortenedURL = ShortenedURL(date: Date(), originalURL: originalURL, shortURL: TinyURLAPI.tinify(url: originalURL))
        self.shortenedURLS.append(shortenedURL)
        
        DispatchQueue.main.async {
            self.shortenedURLSTableView.reloadData()
            self.urlField.resignFirstResponder()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup as the data source
        shortenedURLSTableView.dataSource = self
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


class ShortURLTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var originalURLLabel: UILabel!
    @IBOutlet weak var shortURLLabel: UILabel!
}
