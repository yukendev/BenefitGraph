//
//  EditViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    var editedCategory = String()
    var editedYear = String()
    var editedMonth = String()
    var editedMoney = String()
    
    var delegate: tableViewReloadDelegate?
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        monthLabel.text = editedYear + "年　" + editedMonth + "月"
        categoryLabel.text = editedCategory
        moneyTextField.text = editedMoney
        
        print("今からこれを編集します")
        print(editedYear)
        print(editedMonth)
        print(editedCategory)
        print(editedMoney)
    }
    

    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editAction(_ sender: Any) {
        if moneyTextField.text == "" {
            showAlert(title: "入力してください")
        }else{
            deleteAction()
            saveAction()
            delegate?.tableViewReload()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func deleteAction() {
        let deletedBemefit = realm.objects(Benefit.self).filter("year == '\(editedYear)' AND month == '\(editedMonth)' AND category == '\(editedCategory)'")
        
        try! realm.write{
            realm.delete(deletedBemefit)
        }
    }
    
    func saveAction() {
        let addedBenefit = Benefit()
        addedBenefit.year = editedYear
        addedBenefit.month = editedMonth
        addedBenefit.category = editedCategory
        addedBenefit.benefit = moneyTextField.text!
        
        try! realm.write{
            realm.add(addedBenefit)
        }
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cansel = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cansel)
        self.present(alertController, animated: true, completion: nil)
    }
}
