//
//  AuthViewController.swift
//  project
//
//  Created by xCressselia on 3/12/2567 BE.
//

import UIKit
import FirebaseAuth
import Combine

class AuthVC: UIViewController {

    enum LoginStatus {
        case signUp
        case signIn
    }
    
    @IBOutlet weak var txtPassWord: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnAccessory: UIButton!
    @IBOutlet weak var btnPrimary: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var cardView: UIView!
    
    var emailIsEmpty = true
    var passwordIsEmpty = true
    
    var loginStatus: LoginStatus = .signUp {
        didSet {
            DispatchQueue.main.async {
                self.lbTitle.text = (self.loginStatus == .signUp) ? "Register" : "Sign In"
                self.btnPrimary.setTitle((self.loginStatus == .signUp) ? "Create An Account" : "Log In", for: .normal)
                self.btnAccessory.setTitle((self.loginStatus == .signUp) ? "Already have account?" : "Don't have an account?", for: .normal)
                self.txtPassWord.textContentType = (self.loginStatus == .signUp) ? .newPassword : .password
            }
            print("LoginStatus changed to: \(loginStatus)")
        }
    }
    
    private var tokens: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView.layer.masksToBounds = true
        cardView.layer.masksToBounds = true
        
        UIView.animate(
            withDuration: 1.0, delay: 0.5, options: .curveEaseInOut) {
                self.cardView.alpha = 1
                self.cardView.frame = self.cardView.frame.offsetBy(dx: 0, dy: 0)
            }
        
        // Publishers to track if the email or password fields are empty
        txtEmail.publisher(for: \.text)
            .sink { newValue in
                self.emailIsEmpty = (newValue == "" || newValue == nil)
            }
            .store(in: &tokens)
        
        txtPassWord.publisher(for: \.text)
            .sink { newValue in
                self.passwordIsEmpty = (newValue == "" || newValue == nil)
            }
            .store(in: &tokens)
    }
    
    @IBAction func btnActionAccessory(_ sender: Any) {
        print("Accessory button pressed") // Debugging log
        self.loginStatus = (self.loginStatus == .signUp) ? .signIn : .signUp
    }
    
    @IBAction func btnActionPrimary(_ sender: Any) {
        if (emailIsEmpty || passwordIsEmpty) {
            let alert = UIAlertController(title: "แจ้งเตือน", message: "กรุณากรอกข้อมูลให้ถูกต้อง ตรวจสอบอีเมลล์หรือรหัสผ่านอีกครั้ง", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if loginStatus == .signUp {
                // Sign Up
                Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassWord.text!) { authResult, error in
                    if let error = error {
                        print("Error signing up: \(error.localizedDescription)")
                        return
                    }
                    self.goToHomeScreen()
                }
            } else {
                // Sign In
                Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassWord.text!) { authResult, error in
                    if let error = error {
                        print("Error signing in: \(error.localizedDescription)")
                        return
                    }
                    self.goToHomeScreen()
                }
            }
        }
    }
    
    func goToHomeScreen() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
