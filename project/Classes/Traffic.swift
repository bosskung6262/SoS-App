//
//  Traffic.swift
//  project
//
//  Created by xCressselia on 28/11/2567 BE.
//

import Foundation
import UIKit

class Traffic {
    var imgShow: UIImage
    
    init(imgShow: UIImage) {
        self.imgShow = imgShow
    }
}

let traffic = [
    Traffic(imgShow: UIImage(named: "TrafficPolice")!),
    Traffic(imgShow: UIImage(named: "TrafficAccident")!),
    Traffic(imgShow: UIImage(named: "Countryside")!)
]
