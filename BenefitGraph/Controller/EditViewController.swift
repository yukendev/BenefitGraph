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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("今からこれを編集します")
        print(editedYear)
        print(editedMonth)
        print(editedCategory)
    }
    

    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
