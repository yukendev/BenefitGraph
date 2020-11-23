//
//  CustomViewCell2.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/23.
//

import UIKit

class CustomViewCell2: UITableViewCell {
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContainer.layer.cornerRadius = 3
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
