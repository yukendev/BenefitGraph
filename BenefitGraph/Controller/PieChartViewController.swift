//
//  PieChartViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import Charts
import RealmSwift

class PieChartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    
    let yearArray: [String] = ["2019", "2020"]
    var categoryArray = [String]()
    var benefitArray = [String]()
    var intBenefitArray = [Int]()
    
    let realm = try! Realm()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearPickerView.delegate = self
        yearPickerView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setCategoryArray()
        
        setPieChart()
    }
    
    func setPieChart() {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<months.count {
            dataEntries.append(PieChartDataEntry(value: Double(benefits[i]), label: monthsString[i] + "月", data: benefits[i]))
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Units Sold")
        pieChart.data = PieChartData(dataSet: pieChartDataSet)

        
        pieChartDataSet.colors = ChartColorTemplates.material()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearArray[row]
    }
    
    func getBenefitFromRealm(year: String) {
        for category in categoryArray {
            intBenefitArray = []
            let categoryBenefit = realm.objects(Benefit.self).filter("year == '\(year)' AND category == '\(category)'")
            if categoryBenefit.count == 0 {
                intBenefitArray.append(0)
                print("\(year)年の\(category)の利益は0円です")
            }else{
                let intBenefit = Int(categoryBenefit[0].benefit!)!
                intBenefitArray.append(intBenefit)
                print("\(year)年の\(category)の利益は\(intBenefit)円です")
            }
        }
    }
    
    func setCategoryArray() {
        categoryArray = []
        let categoryArrayFromRealm = realm.objects(Category.self)
        for category in categoryArrayFromRealm {
            categoryArray.append(category.categoryName!)
        }
    }
    
}
