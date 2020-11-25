//
//  CustomViewCell1.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/23.
//

import UIKit

class CustomViewCell1: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    let categoryArray: [String] = ["アフィリエイト１", "アフィリエイト２", "アドセンス"]
    let moneyArray: [String] = ["1232円", "1452円", "349円"]
    
    var delegate: toDetailDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContainer.layer.borderWidth = 1.0
        cellContainer.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        cellContainer.layer.cornerRadius = 3
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomViewCell2", bundle: nil), forCellReuseIdentifier: "CustomCell2")
        
        tableView.separatorStyle = .none
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! CustomViewCell2
        
        cell.selectionStyle = .none
        cell.categoryLabel.text = categoryArray[indexPath.row]
        cell.moneyLabel.text = moneyArray[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.toDetail()
        print("中のcellが押されました")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
