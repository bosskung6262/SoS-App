//
//  HealthDetailsVC.swift
//  project
//
//  Created by xCressselia on 30/11/2567 BE.
//
import UIKit
import CoreLocation
import MessageUI

class HealthDetailsVC: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    var selectedIndex: Int?  // Declare selectedIndex here
    
    var orgName: [String] = []
    var telNum: [String] = []
    var orgDetails: [String] = []
    var imgIcon: [UIImage] = []

    @IBOutlet weak var lbDetails: UILabel!
    @IBOutlet weak var txtTelNum: UITextField!
    @IBOutlet weak var lbOrganize: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    // Core Location Manager
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Selected Index in viewDidLoad of HealthDetailsVC: \(String(describing: selectedIndex))")
        
        loadDataFromPlist()
        
        // Set up location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        if let index = selectedIndex {
            displayData(at: index)
        } else {
            print("❌ Invalid index or empty data")
        }
    }
    
    func loadDataFromPlist() {
        // Get the file path for the plist
        if let path = Bundle.main.path(forResource: "health", ofType: "plist") {
            print("Plist file found at path: \(path)")
            
            do {
                // Deserialize plist into a dictionary
                let xml = try Data(contentsOf: URL(fileURLWithPath: path))
                
                if let plist = try PropertyListSerialization.propertyList(from: xml, options: [], format: nil) as? [String: Any] {
                    
                    // Load the values from the plist into respective arrays
                    orgName = plist["orgName"] as? [String] ?? []
                    telNum = plist["telNum"] as? [String] ?? []
                    orgDetails = plist["orgDetails"] as? [String] ?? []
                    
                    // Load the image filenames (as strings) from the plist
                    if let imageNames = plist["imgIcon"] as? [String] {
                        // Convert image filenames to UIImage objects
                        imgIcon = imageNames.compactMap { UIImage(named: $0) }
                    }
                    
                    // Debugging: print out loaded data
                    print("Loaded orgName: \(orgName)")
                    print("Loaded telNum: \(telNum)")
                    print("Loaded orgDetails: \(orgDetails)")
                    print("Loaded imgIcon: \(imgIcon)")
                    
                } else {
                    print("❌ Failed to cast plist into dictionary.")
                }
            } catch {
                print("Failed to load plist: \(error)")
            }
        } else {
            print("❌ Plist file not found.")
        }
    }
    
    func displayData(at index: Int) {
        guard index < orgName.count else {
            print("❌ Invalid index, out of bounds")
            return
        }
        
        // Safely retrieve data for the given index
        let organization = orgName[index]
        let tel = telNum[index]
        let details = orgDetails[index]
        let img = imgIcon[index]
        
        // Update UI elements
        DispatchQueue.main.async {
            self.lbOrganize.text = organization
            self.lbDetails.text = details
            self.txtTelNum.text = tel
            self.imgLogo.image = img
        }
        
        // Force a layout update
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnCopy(_ sender: UIButton) {
        if txtTelNum.text?.isEmpty == false {
            UIPasteboard.general.string = txtTelNum.text
            print("✅ คัดลอกหมายเลข: \(txtTelNum.text ?? "")")

            let alert = UIAlertController(title: "สำเร็จ", message: "คุณได้คัดลอกหมายเลขเรียบร้อยแล้ว", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            print("❌ ไม่มีหมายเลขให้คัดลอก")

            let alert = UIAlertController(title: "ล้มเหลว", message: "ไม่มีหมายเลขให้คัดลอก", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEmergency(_ sender: Any) {
        if let location = currentLocation {
            print("ช่วยด้วยฉันตกอยู่ในอันตราย ละติจูด: \(location.coordinate.latitude), ลองติจูด: \(location.coordinate.longitude)")
        } else {
            print("ช่วยด้วยฉันตกอยู่ในอันตราย พิกัด: ไม่พบตำแหน่ง")
        }

        // ส่ง SMS
        sendSMS()
        }

        func sendSMS() {
            // เช็คว่ามีข้อมูลตำแหน่งหรือไม่
            guard let location = currentLocation else {
                print("❌ Location is not available yet.")
                return
            }
            
            // สร้างข้อความที่จะส่ง
            let messageBody = "ช่วยด้วย! ฉันตกอยู่ในอันตราย พิกัด: \(location.coordinate.latitude), \(location.coordinate.longitude)"
            
            // ตรวจสอบว่าอุปกรณ์สามารถส่งข้อความได้
            if MFMessageComposeViewController.canSendText() {
                // สร้าง view controller สำหรับส่งข้อความ
                let messageController = MFMessageComposeViewController()
                
                // ตั้งค่าหมายเลขโทรศัพท์ผู้รับ
                if let index = selectedIndex, index < telNum.count {
                    let phoneNumber = telNum[index]
                    messageController.recipients = [phoneNumber]
                }
                
                // ตั้งค่าข้อความ
                messageController.body = messageBody
                
                // ตั้งค่าตัวแทน (delegate)
                messageController.messageComposeDelegate = self
                
                // ใช้ DispatchQueue.main เพื่อแสดงบน main thread
                DispatchQueue.main.async {
                    self.present(messageController, animated: true, completion: nil)
                }
            } else {
                print("❌ This device cannot send SMS.")
            }
        }

        // Delegate method for MFMessageComposeViewController
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case .sent:
                print("Message sent successfully.")
            case .failed:
                print("Failed to send message.")
            case .cancelled:
                print("Message sending cancelled.")
            @unknown default:
                print("Unknown result.")
            }
            
            // ปิด MessageComposeViewController
            controller.dismiss(animated: true, completion: nil)
        }

    
    // CLLocationManagerDelegate method to handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only update the location once
        if let newLocation = locations.last {
            currentLocation = newLocation
//            print("สถานที่ปัจจุบัน : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
}
