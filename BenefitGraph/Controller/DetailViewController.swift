//
//  DetailViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, toEditDelegate, tableViewReloadDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    
    var categoryArray = [String]()
    var moneyArray = [String]()
    
    @IBOutlet weak var headerView: UIView!
    var year = String()
    var month = String()
    
    var editedCategory = String()
    var editedYear = String()
    var editedMonth = String()
    var editedMoney = String()
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomViewCell3", bundle: nil), forCellReuseIdentifier: "CustomCell3")
        tableView.separatorStyle = .none
        
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.view.frame.height * 114/896, width: self.view.frame.width, height: 0.5)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        
        headerView.layer.addSublayer(bottomLayer)
        
        if self.view.frame.height <= 700 {
            headerViewHeight.constant = self.view.frame.height * 114/896
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        detailLabel.text = year + "年" + month + "月"
        getFromRealm()
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell3", for: indexPath) as! CustomViewCell3
        
        cell.categoryLabel.text = categoryArray[indexPath.row]
        cell.moneyLabel.text = moneyArray[indexPath.row] + "円"
        
        cell.category = categoryArray[indexPath.row]
        cell.year = year
        cell.month = month
        cell.money = moneyArray[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        showAlert(category: categoryArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "削除"
    }
    
    func getFromRealm() {
        categoryArray = []
        moneyArray = []
        
        let benefitArray = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)'")
        for benefit in benefitArray {
            categoryArray.append(benefit.category!)
            moneyArray.append(benefit.benefit!)
        }
        tableView.reloadData()
        
    }
    
    func showAlert(category: String) {
        let alertController = UIAlertController(title: "本当に削除しますか？", message: "", preferredStyle: .alert)
        let delete = UIAlertAction(title: "はい", style: .default) { _ in
            self.deleteAction(category: category)
        }
        let cansel = UIAlertAction(title: "いいえ", style: .cancel)
        
        alertController.addAction(delete)
        alertController.addAction(cansel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAction(category: String) {
        
        let deletedBenefitArray = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)' AND category == '\(category)'")
        
        try! realm.write{
            realm.delete(deletedBenefitArray)
        }
        
        getFromRealm()
        if categoryArray.count == 0 {
            dismiss(animated: true, completion: nil)
        }else{
            
        }
    }
    
    func toEdit(category: String, year: String, month: String, money: String) {
        editedCategory = category
        editedYear = year
        editedMonth = month
        editedMoney = money
        performSegue(withIdentifier: "edit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! EditViewController
        nextVC.editedCategory = editedCategory
        nextVC.editedYear = editedYear
        nextVC.editedMonth = editedMonth
        nextVC.editedMoney = editedMoney
        nextVC.delegate = self
    }
    
    func tableViewReload() {
        getFromRealm()
    }


}
