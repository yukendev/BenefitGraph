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
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    
    
    var categoryArray = [String]()
    var moneyArray = [String]()
    var year = String()
    var month = String()
    
    var delegate: toDetailDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContainer.layer.borderWidth = 1.0
        cellContainer.layer.borderColor = UIColor.gray.cgColor
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
        
        print("こちらセルの中です")
        print(categoryArray[indexPath.row])
        print(moneyArray[indexPath.row])
        
        cell.selectionStyle = .none
        
        cell.categoryLabel.text = categoryArray[indexPath.row]
        cell.moneyLabel.text = moneyArray[indexPath.row] + "円"
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.toDetail(year: year, month: month)
        print("中のcellが押されました")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setHeight() {
        if moneyArray.count >= 3 {
            tableViewHeight.constant = 200
        }else{
            tableViewHeight.constant = CGFloat(tableView.contentSize.height + 40)
        }
    }
    
}
