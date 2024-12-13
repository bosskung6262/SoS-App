//
//  Health.swift
//  project
//
//  Created by xCressselia on 28/11/2567 BE.
//

import Foundation
import UIKit

class Health {
    var imgShow: UIImage
    
    init(imgShow: UIImage) {
        self.imgShow = imgShow
    }
}

let health = [
    Health(imgShow: UIImage(named: "MedicalAccident")!),
    Health(imgShow: UIImage(named: "Rescue")!)
]
