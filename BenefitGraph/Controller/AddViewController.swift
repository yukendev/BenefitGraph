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
    
    var yearArray = [String]()
    var monthArray = [String]()
    var categoryArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        monthPickerView.selectRow(0, inComponent: 0, animated: false)
        monthPickerView.selectRow(1, inComponent: 1, animated: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        yearArray = ["2020年", "2021年", "2022年"]
        
        monthArray = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
        
        categoryArray = ["アフィリエイト１", "アフィリエイト2", "アドセンス"]
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            switch component {
            case 0:
                return yearArray.count
            case 1:
                return monthArray.count
            default:
                return 0
            }
        case 1:
            return categoryArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 0:
            switch component {
            case 0:
                return yearArray[row]
            case 1:
                return monthArray[row]
            default:
                return ""
            }
        case 1:
            return categoryArray[row]
        default:
            return ""
        }
        
//        return addArray[pickerView.tag][row]
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
