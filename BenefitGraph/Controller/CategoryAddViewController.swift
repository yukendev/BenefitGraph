//
//  CategoryAddViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/23.
//

import UIKit
import RealmSwift

class Category: Object {
    @objc dynamic var categoryName: String?
}

class CategoryAddViewController: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        
        addButton.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("わしょい")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        if textField.text == "" {
            showAlert(title: "入力してください")
        }else{
            if doubleCategory(text: textField.text!) {
                showAlert(title: "同じ名前のカテゴリーは一つまでです")
            }else{
//                realmに追加
                let category = Category()
                category.categoryName = textField.text
                try! realm.write{
                    realm.add(category)
                }
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cansel = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cansel)
                
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func doubleCategory(text: String)-> Bool {
        let categories = realm.objects(Category.self).filter("categoryName == '\(text)'")
        if categories.count == 0 {
            return false
        }else{
            return true
        }
    }

    
    
    
}
