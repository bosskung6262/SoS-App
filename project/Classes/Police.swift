//
//  Police.swift
//  project
//
//  Created by xCressselia on 27/11/2567 BE.
//

import Foundation
import UIKit

class PoliceAndSecurity {
    var imgShow: UIImage
    
    init(imgShow: UIImage) {
        self.imgShow = imgShow
    }
}

let policeAndSecurity = [
    PoliceAndSecurity(imgShow: UIImage(named: "CallPolice")!),
    PoliceAndSecurity(imgShow: UIImage(named: "TourPolice")!),
    PoliceAndSecurity(imgShow: UIImage(named: "CarThief")!)
]
