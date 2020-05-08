//
//  DetailedActivityViewController.swift
//  Project7
//
//  Created by student on 3/2/20.
//  Copyright © 2020 CSC509. All rights reserved.
//
import Foundation
import UIKit

class DetailedActivityViewController: UIViewController {

    // Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descriptionLabel: UITextView!
    
    // Variable declarations
    let defaults = UserDefaults.standard
    var activity: [String] = []
    let encoder = JSONEncoder()
    var slcstudentActivity: [String] = []
    var studentID: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = defaults.array(forKey: "user") as? [String] {
            studentID = user
        }
        viewDidAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let slcActivity = defaults.array(forKey: "slcActivity") as? [String] {
                activity = slcActivity
            }
        // Text population
        nameLabel.text = activity[0]
        timeLabel.text = "\(activity[1]) - \(activity[2])"
        descriptionLabel.text = activity[3]
        locationLabel.text = activity[4]
    }
}
