//
//  EditViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit

class EditViewController: UIViewController {
    
    var editedCategory = String()
    var editedYear = String()
    var editedMonth = String()
    var editedMoney = String()
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!
    
    

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
        
    }
    
}
