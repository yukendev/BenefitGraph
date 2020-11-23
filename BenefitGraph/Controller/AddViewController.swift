//
//  AddViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    var addArray = [[String]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        addArray = [[], []]
        
        addArray[0] = ["2020年 10月", "2020年 11月", "2020年 12月"]
        addArray[1] = ["アフィリエイト１", "アフィリエイト２", "アドセンス"]
        
        print(addArray)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return addArray[pickerView.tag].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return addArray[pickerView.tag][row]
    }
    

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func categoryEditAction(_ sender: Any) {
        performSegue(withIdentifier: "categoryEdit", sender: nil)
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
