//
//  TrafficVC.swift
//  project
//
//  Created by xCressselia on 27/11/2567 BE.
//
import Foundation
import UIKit

class TrafficVC: UIViewController {

    var selectedIndex: Int?
    
    @IBOutlet weak var trafficTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        trafficTableView.delegate = self
        trafficTableView.dataSource = self
        trafficTableView.layer.masksToBounds = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trafficSegue" {
            if let trafficDetailsVC = segue.destination as? TrafficDetailsVC {
                trafficDetailsVC.selectedIndex = selectedIndex
            }
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TrafficVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return traffic.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trafficCell", for: indexPath) as! TrafficTVCell
        let traffic = traffic[indexPath.section]
        
        cell.btnBarTraffic.image = traffic.imgShow
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.section // Use section instead of row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "trafficSegue", sender: nil) // Perform the segue
    }
}
