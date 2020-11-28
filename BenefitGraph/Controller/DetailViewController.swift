//
//  DetailViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var categoryArray = [String]()
    var moneyArray = [String]()
    
    var year = String()
    var month = String()
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomViewCell3", bundle: nil), forCellReuseIdentifier: "CustomCell3")
        tableView.separatorStyle = .none
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("さぁ、いくぞ")
        print(year)
        print(month)
        getFromRealm()
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
    
    func getFromRealm() {
        categoryArray = []
        moneyArray = []
        
        let benefitArray = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)'")
        for benefit in benefitArray {
            categoryArray.append(benefit.category!)
            moneyArray.append(benefit.benefit!)
        }
        
        print("getFromRealm発動")
        print(categoryArray)
        print(moneyArray)
        tableView.reloadData()
        
    }
    


}
