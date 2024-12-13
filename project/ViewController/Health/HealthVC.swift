//
//  HealthVC.swift
//  project
//
//  Created by xCressselia on 27/11/2567 BE.
//
import Foundation
import UIKit

class HealthVC: UIViewController {

    var selectedIndex: Int?
    
    @IBOutlet weak var healthTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        healthTableView.delegate = self
        healthTableView.dataSource = self
        healthTableView.layer.masksToBounds = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "healthSegue" {
            if let healthDetailsVC = segue.destination as? HealthDetailsVC {
                healthDetailsVC.selectedIndex = selectedIndex
            }
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension HealthVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return health.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthCell", for: indexPath) as! HealthTVCell
        let health = health[indexPath.section]
        
        cell.btnBarHealth.image = health.imgShow
        
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
        performSegue(withIdentifier: "healthSegue", sender: nil) // Perform the segue
    }
}
