//
//  DetailViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let categoryArray: [String] = ["アフィリエイト１", "アフィリエイト２", "アドセンス"]
    let moneyArray: [String] = ["1232円", "1452円", "349円"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomViewCell3", bundle: nil), forCellReuseIdentifier: "CustomCell3")
        tableView.separatorStyle = .none
        
        

    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editAction(_ sender: Any) {
        performSegue(withIdentifier: "edit", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell3", for: indexPath) as! CustomViewCell3
        
        cell.categoryLabel.text = categoryArray[indexPath.row]
        cell.moneyLabel.text = moneyArray[indexPath.row]
        
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    


}
