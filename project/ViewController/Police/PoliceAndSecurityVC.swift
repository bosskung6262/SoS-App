//
//  PoliceAndSecurityVC.swift
//  project
//
//  Created by xCressselia on 27/11/2567 BE.
//
import Foundation
import UIKit

class PoliceAndSecurityVC: UIViewController {
    
    var selectedIndex: Int?
    
    @IBOutlet weak var policeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        policeTableView.delegate = self
        policeTableView.dataSource = self
        policeTableView.layer.masksToBounds = false
        
    }
    
    // In the previous view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "policeSegue" {
            if let policeDetailsVC = segue.destination as? PoliceDetailsVC {
                policeDetailsVC.selectedIndex = selectedIndex
            }
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PoliceAndSecurityVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return policeAndSecurity.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "policeCell", for: indexPath) as? PoliceAndSecurityTVCell else {
            return UITableViewCell()
        }
        let police = policeAndSecurity[indexPath.section]
        cell.btnBarPolice.image = police.imgShow
        
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
        performSegue(withIdentifier: "policeSegue", sender: nil) // Perform the segue
    }

}
