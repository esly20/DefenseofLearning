//
//  ScheduleCollectionViewController.swift
//  Project7
//
//  Created by student on 2/20/20.
//  Copyright © 2020 CSC509. All rights reserved.
//
import UIKit
import Foundation

class ScheduleCollectionViewController: UICollectionViewController {
    var frame = CGRect.zero
    var schedule = [Course]()
    
    let reuseIdentifier = "BlockCell"
    let itemsPerRow: CGFloat = 1
    let sectionInsets = UIEdgeInsets(top: 10.0,
                                     left: 30.0,
                                     bottom: 10.0,
                                     right: 30.0)
    var pageDays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    var weekDays: [String] = ["Day"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    func setupScreens() {
        for index in 0..<pageDays.count {
            // 1.
            frame.origin.x = collectionView.frame.size.width * CGFloat(index)
            frame.size = collectionView.frame.size
        }
    }
    @objc func fetchJSON() {
        let urlString: String
        
        urlString = "https://summer-session-api.herokuapp.com/student/1/schedule"
        
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    return
                }
            }
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonSchedule = try? decoder.decode(Schedule.self, from: json) {
            schedule = jsonSchedule.schedule
            
            collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return weekDays.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedule.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cell setup
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlockCell", for: indexPath) as! ScheduleCollectionViewCell
        let course = schedule[indexPath.row]
        cell.nameLabel.textAlignment = .center
        cell.timeStartLabel.textAlignment = .center
        cell.instructorLabel.textAlignment = .center
        cell.locationLabel.textAlignment = .center
        cell.nameLabel.text = course.name
        cell.timeStartLabel.text = "\(course.time_start) - \(course.time_end)"
        cell.instructorLabel.text = course.instructor
        cell.locationLabel.text = course.location
        // Styling
        cell.backgroundColor = UIColor.init(red: 102/256, green: 173/256, blue: 220/256, alpha: 0.50)
        return cell
    }
}

// Collection View setup
extension ScheduleCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
