//
//  Water.swift
//  project
//
//  Created by xCressselia on 28/11/2567 BE.
//

import Foundation
import UIKit

class Water {
    var imgShow: UIImage
    
    init(imgShow: UIImage) {
        self.imgShow = imgShow
    }
}

let water = [
    Water(imgShow: UIImage(named: "WaterAccident")!),
    Water(imgShow: UIImage(named: "WaterPolice")!)
]
