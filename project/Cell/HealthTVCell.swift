//
//  HealthTVCell.swift
//  project
//
//  Created by xCressselia on 27/11/2567 BE.
//

import Foundation
import UIKit

class HealthTVCell: UITableViewCell {

    @IBOutlet weak var btnBarHealth: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(named: "Shadow")!.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
