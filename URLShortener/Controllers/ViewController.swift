//
//  ViewController.swift
//  URLShortener
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let dao = ShortenedURLDAO()
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
        
        // Use simplified API.
        TinyURLAPI.tinify(url: originalURL, completion: { (shortURL:URL?) -> Void in
            
            if let shortURL = shortURL {
                
                let shortenedURL = ShortenedURL(date: Date(), originalURL: originalURL, shortURL: shortURL)
                self.shortenedURLS.append(shortenedURL)
                
                // Save using DAO.
                self.dao.saveShortenedURLS(self.shortenedURLS)
                
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
        
        // Load using DAO.
        shortenedURLS = dao.loadShortenedURLS()
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
        
        // First check if we can open it.
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
