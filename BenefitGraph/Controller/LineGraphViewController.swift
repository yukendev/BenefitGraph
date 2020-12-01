//
//  LineGraphViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import Charts
import RealmSwift




class LineGraphViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    let months: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let monthsString: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var benefits: [Int] = [12, 14, 2778, 59, 49, 35090, 12, 3432, 43, 243, 123, 126]
//    let exampleArray1: [String] = ["2018", "2019", "2020"]
//    let exampleArray2: [String] = ["アフィリエイト", "アドセンス"]
    var year = String()
    var category = String()
    
    var yearArray = [String]()
    var categoryArray = [String]()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        setLineGraph()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getYearAndCategory()
        
        category = categoryArray[0]
        year = yearArray[0]
        
        reloadGraph(category: category, year: Int(year)!)
    }
    
    func setLineGraph(){
        var entry = [ChartDataEntry]()
        
        for (i,d) in benefits.enumerated(){
            entry.append(ChartDataEntry(x: months[i],y: Double(d)))
        }
        
        let dataset = LineChartDataSet(entries: entry,label: "Units Sold")
                
        lineChart.data = LineChartData(dataSet: dataset)
        lineChart.chartDescription?.text = "Item Sold Chart"
    }
    
    func getFromRealm() -> [Int] {
        let benefitArray = realm.objects(Benefit.self)
        var yearStringArray: [String] = []
        for benefit in benefitArray {
            yearStringArray.append(benefit.year!)
        }
        var yearIntArray: [Int] = []
        for stringYear in arrayFilter(array: yearStringArray) {
            yearIntArray.append(Int(stringYear)!)
        }
        yearIntArray.sort { $0 < $1 }
//        yearStringArray = yearIntArray.map({ (yearInt: Int) -> String in
//            return String(yearInt)
//        })
        return yearIntArray
    }
    
    func arrayFilter(array: [String]) -> [String] {
        let result = NSOrderedSet(array: array)
        let anyArray = result.array
        let resultArray: [String] = anyArray.map {$0 as! String}
          
        return resultArray
    }
    
    func getBenefitFromRealm(category: String, year: Int) -> [Int] {
        switch category {
        case "全て":
            var allBenefits = [Int]()
            for month in monthsString {
                let monthBenefit = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)'")
                if monthBenefit.count == 0 {
                    allBenefits.append(0)
                    print("\(year)年 \(month)月の利益は0円です")
                }else{
                    var benefitString = [String]()
                    for benefit in monthBenefit {
                        benefitString.append(benefit.benefit!)
                    }
                    let benefitInt = benefitString.map { (benefit) -> Int in
                        return Int(benefit)!
                    }
                    var result: Int = 0
                    for benefit in benefitInt {
                        result += benefit
                    }
                    allBenefits.append(result)
                    print("\(year)年 \(month)月の利益は\(result)円です")
                }
            }
            return allBenefits
        default:
            var allBenefits = [Int]()
            for month in monthsString {
                let monthCategoryBenefit = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)' AND category == '\(category)'")
                if monthCategoryBenefit.count == 0 {
                    allBenefits.append(0)
                    print("\(year)年 \(month)月の\(category)の利益は0円です")
                }else{
                    var stringBenefit = String()
                    for benefit in monthCategoryBenefit {
                        stringBenefit = benefit.benefit!
                    }
                    allBenefits.append(Int(stringBenefit)!)
                    print("\(year)年 \(month)月の\(category)の利益は\(stringBenefit)円です")
                }
            }
            return allBenefits
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return yearArray.count
        case 1:
            return categoryArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return yearArray[row]
        case 1:
            return categoryArray[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            year = yearArray[row]
            reloadGraph(category: category, year: Int(year)!)
        case 1:
            category = categoryArray[row]
            reloadGraph(category: category, year: Int(year)!)
        default:
            print("エラーです")
        }
    }
    
    func getYearAndCategory() {
        yearArray = []
        categoryArray = ["全て"]
        let yearIntArray = getFromRealm()
        for year in yearIntArray {
            yearArray.append(String(year))
        }
        let resultArray = realm.objects(Category.self)
        for category in resultArray {
            categoryArray.append(category.categoryName!)
        }
        yearPickerView.reloadAllComponents()
        categoryPickerView.reloadAllComponents()
    }
    
    func reloadGraph(category: String, year: Int) {
        benefits = getBenefitFromRealm(category: category, year: year)
        
        setLineGraph()
    }

}
