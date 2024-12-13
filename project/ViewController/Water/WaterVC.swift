//
//  WaterVC.swift
//  project
//
//  Created by xCressselia on 27/11/2567 BE.
//
import Foundation
import UIKit

class WaterVC: UIViewController {

    var selectedIndex: Int?
    
    @IBOutlet weak var waterTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        waterTableView.delegate = self
        waterTableView.dataSource = self
        waterTableView.layer.masksToBounds = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "waterSegue" {
            if let waterDetailsVC = segue.destination as? WaterDetailsVC {
                waterDetailsVC.selectedIndex = selectedIndex
            }
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension WaterVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return water.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "waterCell", for: indexPath) as! WaterTVCell
        let water = water[indexPath.section]
        
        cell.btnBarWater.image = water.imgShow
        
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
        performSegue(withIdentifier: "waterSegue", sender: nil) // Perform the segue
    }
}
