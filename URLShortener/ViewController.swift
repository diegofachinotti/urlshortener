//
//  ViewController.swift
//  URLShortener
//
//  Created by Diego Fachinotti on 21.03.2019.
//  Copyright © 2019 Diego Fachinotti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var shortenedURLSTableView: UITableView!
    
    @IBAction func shortenTouched(_ sender: Any) {
        // TODO: Implement
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


class ShortURLTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var originalURLLabel: UILabel!
    @IBOutlet weak var shortURLLabel: UILabel!
}
