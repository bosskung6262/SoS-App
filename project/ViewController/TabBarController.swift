//
//  TabBarController.swift
//  project
//
//  Created by xCressselia on 26/11/2567 BE.
//
import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.selectionIndicatorImage = UIImage(named: "Selected")
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.tabBar.tintColor = .white
    }
    

}
