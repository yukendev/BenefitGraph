//
//  AddViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import RealmSwift



class Benefit: Object {
    @objc dynamic var year: String?
    @objc dynamic var month: String?
    @objc dynamic var category: String?
    @objc dynamic var benefit: String?
}

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, setCategoryDelegate {
    
    
    
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    
    
    var yearArray = [String]()
    var monthArray: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var categoryArray = [String]()
    
    var selectedYear = String()
    var selectedMonth = String()
    var selectedCategory = String()
    
    let realm = try! Realm()
    
    var tableViewReloadDelegate: tableViewReloadDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        moneyTextField.delegate = self
        
        setYearArray()
        monthPickerView.selectRow(getMonth(), inComponent: 1, animated: false)
        monthPickerView.selectRow(getYear(), inComponent: 0, animated: false)
        
        editButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        editButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
        addButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        addButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
        addButton.layer.cornerRadius = 5
        
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
        
        setCategoryArray()
        
        selectedYear = yearArray[getYear()]
        selectedMonth = monthArray[getMonth()]
        
    }
    
    @objc func pushButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations:{ () -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
        
        
    @objc func separateButton_Animation(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, animations:{ () -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
                return yearArray[row] + "年"
            case 1:
                return monthArray[row] + "月"
            default:
                return ""
            }
        case 1:
            return categoryArray[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            switch component {
            case 0:
                print("年選択")
                selectedYear = yearArray[row]
            case 1:
                print("月選択")
                selectedMonth = monthArray[row]
            default:
                print("エラー")
            }
        case 1:
            print("カテゴリー選択")
            selectedCategory = categoryArray[row]
        default:
            print("エラー")
        }
    }
    

    @IBAction func backAction(_ sender: Any) {
        tableViewReloadDelegate?.tableViewReload()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func categoryEditAction(_ sender: Any) {
        performSegue(withIdentifier: "categoryEdit", sender: nil)
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        print(selectedYear)
        print(selectedMonth)
        print(selectedCategory)
        if moneyTextField.text == ""{
            print("空白はダメ")
            showAlert(title: "入力してください", type: "blank")
        }else{
            if isDoubled(year: selectedYear, month: selectedMonth, category: selectedCategory) {
                print("かぶってるよ")
                showAlert(title: "同じ月、同じカテゴリーにすでに記録があります。上書きしますか？", type: "double")
            }else{
                addToRealm()
            }
        }
    }
    
    func setCategoryArray() {
        let realmCategoryArray = realm.objects(Category.self)
        categoryArray = []
        if realmCategoryArray.count == 0{
            let category = Category()
            category.categoryName = "カテゴリー１"
            try! realm.write{
                realm.add(category)
            }
            categoryArray = ["カテゴリー１"]
        }else{
            for category in realmCategoryArray {
                categoryArray.append(category.categoryName!)
            }
        }
        selectedCategory = categoryArray[0]
    }
    
    func setYearArray() {
        yearArray = []
        
        for i in 1900..<2101 {
            yearArray.append(String(i))
        }
    }
    
    func getYear()-> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale.current)
        let year = formatter.string(from: Date())
        return Int(year)! - 1900
    }
    
    func getMonth()-> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM", options: 0, locale: Locale.current)
        let month = formatter.string(from: Date())
        
        return Int(month)! - 1
    }
    
    func showAlert(title: String, type: String) {
        switch type {
        case "blank":
            let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
            let cansel = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(cansel)
                    
            self.present(alertController, animated: true, completion: nil)
        case "double":
            let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
            let cansel = UIAlertAction(title: "いいえ", style: .cancel)
            let action1 = UIAlertAction(title: "はい", style: .default) { [self] _ in
                self.reRecord(year: selectedYear, month: selectedMonth, category: selectedCategory)
            }
            alertController.addAction(cansel)
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        default:
            print("エラー")
        }
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cansel = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cansel)
                
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addToRealm() {
        let benefit = Benefit()
        benefit.year = selectedYear
        benefit.month = selectedMonth
        benefit.benefit = moneyTextField.text
        benefit.category = selectedCategory
        
        try! realm.write{
            realm.add(benefit)
        }
        dismiss(animated: true, completion: nil)
        tableViewReloadDelegate?.tableViewReload()
    }
    
    func isDoubled(year: String, month: String, category: String)-> Bool {
        let benefit = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)' AND category == '\(category)'")
        if benefit.count == 0{
            return false
        }else{
            return true
        }
    }

    func reRecord(year: String, month: String, category: String) {
        print("上書き保存")
        let deletedBenefit = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)' AND category == '\(category)'")
        try! realm.write{
            realm.delete(deletedBenefit)
        }
        
        addToRealm()
    }
    
    func updateCategoryArray() {
        print("大成功！！！")
        setCategoryArray()
        categoryPickerView.reloadAllComponents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! CategoryEditViewController
        nextVC.setCategoryDelegate = self
    }
    
}
