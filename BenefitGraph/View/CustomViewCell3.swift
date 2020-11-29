//
//  CustomViewCell3.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/23.
//

import UIKit

class CustomViewCell3: UITableViewCell {
    
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    var category = String()
    var year = String()
    var month = String()
    var money = String()
    
    var delegate: toEditDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContainer.layer.cornerRadius = 3
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func editAction(_ sender: Any) {
        print("編集")
        delegate?.toEdit(category: category, year: year, month: month, money: money)
    }
    
    
}
