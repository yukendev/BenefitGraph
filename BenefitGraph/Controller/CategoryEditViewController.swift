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
        
        deleteCategory(category: categoryArray[indexPath.row])
        print(categoryArray[indexPath.row])
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
