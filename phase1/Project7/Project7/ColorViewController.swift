//
//  ColorViewController.swift
//  Project7
//
//  Created by student on 4/13/20.
//  Copyright © 2020 CSC509. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    var num: Int = 0
    
    @IBOutlet var numLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeColorPressed(_ sender: Any) {
        num += 1
        numLabel.text = "\(num)"
    }
}
