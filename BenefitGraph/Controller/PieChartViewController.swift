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
    
    var yearArray = [String]()
    var categoryArray = [String]()
    var benefitArray = [String]()
    var intBenefitArray = [Int]()
    var finalBenefits = [Int]()
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearPickerView.delegate = self
        yearPickerView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        yearPickerView.selectRow(yearArray.count - 1, inComponent: 0, animated: true)
        
        setYearArray()
        
        setBenefit(year: "2020")
    }
    
    
    
    
    
    
    
    func setPieChart() {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<categoryArray.count {
            dataEntries.append(PieChartDataEntry(value: Double(finalBenefits[i]), label: categoryArray[i], data: finalBenefits[i]))
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(yearArray[row])年の利益です")
        setBenefit(year: yearArray[row])
    }
    
    func setBenefit(year: String) {
        categoryArray = []
        benefitArray = []
        intBenefitArray = []
        finalBenefits = []
        let categoryArrayFromRealm = realm.objects(Category.self)
        for category in categoryArrayFromRealm {
            categoryArray.append(category.categoryName!)
        }
        for category in categoryArray {
            var finalResult = 0
            let benefitArrayResult = realm.objects(Benefit.self).filter("year == '\(year)' AND category == '\(category)'")
            if benefitArrayResult.count == 0 {
                print("この年の\(category)の利益は0円です")
                finalBenefits.append(0)
            }else{
                for benefit in benefitArrayResult {
                    benefitArray.append(benefit.benefit!)
                }
                for benefit in benefitArray {
                    intBenefitArray.append(Int(benefit)!)
                }
                for intBenefit in intBenefitArray {
                    finalResult += intBenefit
                }
                print("この年の\(category)の利益は\(finalResult)円です")
                finalBenefits.append(finalResult)
            }
        }
        setPieChart()
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
