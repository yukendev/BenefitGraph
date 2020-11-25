//
//  CategoryEditViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/23.
//

import UIKit
import RealmSwift

class CategoryEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryArray = [String]()
    
    let realm = try! Realm()
    
    var setCategoryDelegate: setCategoryDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomViewCell4", bundle: nil), forCellReuseIdentifier: "CustomCell4")
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        resetCategoryArray()
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        showAlert(title: "本当に削除しますか？", type: "delete", category: categoryArray[indexPath.row])

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
        setCategoryDelegate?.updateCategoryArray()
        dismiss(animated: true, completion: nil)
    }
    
    func resetCategoryArray() {
        let categories = realm.objects(Category.self)
        categoryArray = []
        if categories.count == 0{
            categoryArray = []
        }else{
            for category in categories {
                categoryArray.append(category.categoryName!)
            }
        }
        tableView.reloadData()
    }
    
    func deleteCategory(category: String) {
        if categoryArray.count == 1 {
            showAlert(title: "カテゴリーは最低1つ必要です", type: "1category", category: "")
        }else{
            let newCategories = realm.objects(Category.self).filter("categoryName != '\(category)'")
            let deletedCategory = realm.objects(Category.self).filter("categoryName == '\(category)'")
            try! realm.write{
                realm.delete(deletedCategory)
            }
            categoryArray = []
            for category in newCategories {
                categoryArray.append(category.categoryName!)
            }
            tableView.reloadData()
        }
    }
    
    func showAlert(title: String, type: String, category: String) {
        switch type {
        case "1category":
            let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
            let cansel = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(cansel)
                    
            self.present(alertController, animated: true, completion: nil)
        case "delete":
            let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
            let cansel = UIAlertAction(title: "いいえ", style: .cancel)
            let action1 = UIAlertAction(title: "はい", style: .default) { _ in
                self.deleteCategory(category: category)
            }
            alertController.addAction(cansel)
            alertController.addAction(action1)
                    
            self.present(alertController, animated: true, completion: nil)
        default:
            print("エラー")
        }
    }
    

}
