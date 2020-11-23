//
//  CategoryEditViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/23.
//

import UIKit

class CategoryEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let categoryArray: [String] = ["アフィリエイト１", "アフィリエイト２", "アドセンス"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomViewCell4", bundle: nil), forCellReuseIdentifier: "CustomCell4")
        tableView.separatorStyle = .none

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell4", for: indexPath) as! CustomViewCell4
        
        cell.categoryLabel.text = categoryArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "categoryAdd", sender: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
