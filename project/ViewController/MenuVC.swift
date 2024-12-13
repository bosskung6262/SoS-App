//
//  MenuVC.swift
//  project
//
//  Created by xCressselia on 7/12/2567 BE.
//

import UIKit
import FirebaseAuth  // Ensure FirebaseAuth is imported

class MenuVC: UIViewController {
    
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()  // Correct Firebase Auth method
            print("User logged out successfully")
            
            // Show an alert after logging out
            showLogoutAlert()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func showLogoutAlert() {
        // Create the alert
        let alert = UIAlertController(title: "ออกจากระบบ", message: "คุณได้ออกจากระบบเสร็จสิ้น", preferredStyle: .alert)
        
        // Add an action to dismiss the alert
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: { _ in
            self.navigateToLoginScreen()  // Navigate to login screen after alert
        }))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToLoginScreen() {
        if let navigationController = self.navigationController {
            print("✅ มี Navigation Controller")
            
            if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthVC") as? AuthVC {
                navigationController.pushViewController(loginVC, animated: true)
            }
        } else {
            print("❌ ไม่มี Navigation Controller")
            
            if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthVC") as? AuthVC {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }
    }
}
