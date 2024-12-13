//
//  LocationVC.swift
//  project
//
//  Created by xCressselia on 7/12/2567 BE.
//

import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var txtLaLong: UITextField!
    @IBOutlet weak var mapShow: MKMapView!

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check if location services are enabled and request permission
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        } else {
            showAlertForSettings()
        }
    }

    @IBAction func btnLocationCopy(_ sender: Any) {
        if txtLaLong.text?.isEmpty == false {
            UIPasteboard.general.string = txtLaLong.text
            print("✅ คัดลอกพิกัด: \(txtLaLong.text ?? "")")

            let alert = UIAlertController(title: "สำเร็จ", message: "คุณได้คัดลอกพิกัดเรียบร้อยแล้ว", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            print("❌ ไม่มีพิกัดให้คัดลอก")

            let alert = UIAlertController(title: "ล้มเหลว", message: "ไม่มีพิกัดให้คัดลอก", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnLocationCurrent(_ sender: UIButton) {
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            // Start updating location
            locationManager.startUpdatingLocation()
        } else {
            // If location services are not enabled, show an alert to guide the user to settings
            showAlertForSettings()
        }
    }

    private func showAlertForSettings() {
        let alert = UIAlertController(
            title: "Location Permission Required",
            message: "Please enable location permissions in Settings to use this feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationVC: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Handle changes in authorization status
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted, start updating location
            locationManager.startUpdatingLocation()
            print("Location permission granted.")
        case .denied, .restricted:
            // Handle denied or restricted permissions
            showAlertForSettings()
        case .notDetermined:
            // If not determined yet, request permission
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("No location data available.")
            return
        }

        // Update the UI on the main thread
        DispatchQueue.main.async {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Update the text field with accurate coordinates
            self.txtLaLong.text = "\(latitude), \(longitude)"
            
            // Create and add a pin (annotation) for the current location
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "ฉัน"
            
            // Remove any existing annotations (optional)
            self.mapShow.removeAnnotations(self.mapShow.annotations)
            
            // Add the new annotation to the map
            self.mapShow.addAnnotation(annotation)
            
            // Set the map region centered on the user's location
            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            self.mapShow.setRegion(region, animated: true)
        }
    }



    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to retrieve location: \(error.localizedDescription)")

        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                print("Location unknown.")
            case .denied:
                showAlertForSettings()
            case .network:
                print("Network issues.")
            default:
                break
            }
        }

        let alert = UIAlertController(
            title: "Error",
            message: "Failed to retrieve location. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
