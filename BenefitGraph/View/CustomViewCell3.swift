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
    @IBOutlet weak var editButton: UIButton!
    
    
    var category = String()
    var year = String()
    var month = String()
    var money = String()
    
    var delegate: toEditDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContainer.layer.cornerRadius = 3
        
        editButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        editButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func pushButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations:{ () -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
        
        
    @objc func separateButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, animations:{ () -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @IBAction func editAction(_ sender: Any) {
        delegate?.toEdit(category: category, year: year, month: month, money: money)
    }
    
    
}
