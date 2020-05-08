//
//  ActivityTableViewController.swift
//  Project7
//
//  Created by student on 2/29/20.
//  Copyright © 2020 CSC509. All rights reserved.
//
import Foundation
import UIKit

class ActivityTableViewController: UITableViewController {
    var activities = [Activity]()
    let grayColor: UIColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    var studentID: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = grayColor
        // tableView.reloadSections(IndexSet(integersIn: 0...), with: UITableView.RowAnimation.fade)

        let urlStringActivity = "https://summer-session-api.herokuapp.com/activities"
        
        if let url = URL(string: urlStringActivity) {
            if let data = try? Data(contentsOf: url) {
                parseActivities(json: data)

                return
            } else {
                print("error getting activty data")
            }
        }
        showError()
    }
    
    func parseActivities(json: Data) {
        let decoder = JSONDecoder()
        if let jsonActivities = try? decoder.decode(Activities.self, from: json) {
            activities
                = jsonActivities.activities
            sleep(3)
            tableView.reloadData()
// got alert SIGKILL when the line about reloading with annimation was here which is funky
            print("successfully loaded  activity data")
        } else {
            print("error decoding activity json")
        }
        let encoder = JSONEncoder()
        if let activityData = try? encoder.encode(activities){
            let defaults = UserDefaults.standard
            defaults.set(activityData, forKey: "ActivityList")
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    // Cell set up
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
        if indexPath.section == 0 {
            let activityItem = activities[indexPath.row]
            cell.nameLabel.text = activityItem.name
            cell.locationLabel.text = activityItem.location
            cell.descriptionLabel.text = activityItem.description
            cell.timeLabel.text = "\(activityItem.time_start) - \(activityItem.time_end)"
            return cell
        }
        return cell
    }
    
    // Section titles
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  "All Campus Activities"
    }
    
    // Cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // VC instantialiation
        let storyboard = UIStoryboard(name: "ActivitiesStoryboard", bundle: nil)
        let selectedVC = storyboard.instantiateViewController(identifier: "SelectedActivityVC") as! DetailedActivityViewController

        // VC push
        navigationController?.pushViewController(selectedVC, animated: true)
    }
}
