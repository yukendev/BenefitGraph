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
    @IBOutlet weak var headerView: UIView!
    
    var yearArray = [String]()
    var categoryArray = [String]()
    var benefitArray = [String]()
    var intBenefitArray = [Int]()
    var finalBenefits = [Int]()
    var totalBenefit = Int()
//    var dataExist = Bool()
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: headerView.frame.height, width: self.view.frame.width, height: 1.0)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        
        headerView.layer.addSublayer(bottomLayer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setYearArray()
        
        if yearArray.count == 0 {
            print("データなし")
        }else{
            yearPickerView.selectRow(yearArray.count - 1, inComponent: 0, animated: true)
            setBenefit(year: yearArray[yearArray.count - 1])
        }
    }
    
    
    
    
    
    
    
    func setPieChart(year: String) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<categoryArray.count {
            dataEntries.append(PieChartDataEntry(value: Double(finalBenefits[i]), label: categoryArray[i], data: finalBenefits[i]))
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "利益")
        pieChartDataSet.valueTextColor = UIColor.black
        pieChartDataSet.entryLabelColor = UIColor.black
        pieChart.data = PieChartData(dataSet: pieChartDataSet)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0

        pieChart.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChart.usePercentValuesEnabled = true

        
        pieChartDataSet.colors = ChartColorTemplates.vordiplom()
        pieChart.drawHoleEnabled = true
        pieChart.legend.enabled = false
        
        pieChart.centerText = "\(year)年\n\(totalBenefit)円"
        
    }
    
    
    
    
    
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if yearArray.count != 0 {
            return yearArray.count
        }else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if yearArray.count != 0 {
            return yearArray[row]
        }else{
            return "データなし"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if yearArray.count != 0 {
            setBenefit(year: yearArray[row])
        }else{
            print("データなし")
        }
    }
    
    func setBenefit(year: String) {
        categoryArray = []
        finalBenefits = []
        totalBenefit = 0
        let categoryArrayFromRealm = realm.objects(Category.self)
        for category in categoryArrayFromRealm {
            categoryArray.append(category.categoryName!)
        }
        print("これが全てのカテゴリーや！")
        print(categoryArray)
        for category in categoryArray {
            benefitArray = []
            intBenefitArray = []
            var finalResult = 0
            let benefitArrayResult = realm.objects(Benefit.self).filter("year == '\(year)' AND category == '\(category)'")
            if benefitArrayResult.count == 0 {
                print("この年の\(category)の利益は0円です")
                finalBenefits.append(0)
            }else{
                for benefit in benefitArrayResult {
                    benefitArray.append(benefit.benefit!)
                }
                print("ここで少しチェック!")
                print(benefitArray)
                for benefit in benefitArray {
                    intBenefitArray.append(Int(benefit)!)
                }
                for intBenefit in intBenefitArray {
                    finalResult += intBenefit
                }
                print("この年の\(category)の利益は\(finalResult)円です")
                finalBenefits.append(finalResult)
            }
            totalBenefit += finalResult
        }
        setPieChart(year: year)
    }
    
    func setYearArray() {
        var resultArray: [String] = []
        var intResultArray: [Int] = []
        let benefitArray = realm.objects(Benefit.self)
        for benefit in benefitArray {
            resultArray.append(benefit.year!)
        }
        resultArray = arrayFilter(array: resultArray)
        for result in resultArray {
            intResultArray.append(Int(result)!)
        }
        intResultArray.sort { $0 < $1 }
        resultArray = []
        for intResult in intResultArray {
            resultArray.append(String(intResult))
        }
        
        yearArray = resultArray
    }
    
    func arrayFilter(array: [String]) -> [String] {
        let result = NSOrderedSet(array: array)
        let anyArray = result.array
        let resultArray: [String] = anyArray.map {$0 as! String}
          
        return resultArray
    }
    
}
