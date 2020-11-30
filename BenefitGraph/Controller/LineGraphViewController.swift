//
//  LineGraphViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import Charts
import RealmSwift




class LineGraphViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    
    let months: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let monthsString: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var benefits: [Int] = [12, 14, 2778, 59, 49, 35090, 12, 3432, 43, 243, 123, 126]
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLineGraph()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        benefits = getBenefitFromRealm(category: "all", year: 2019)
        
        setLineGraph()
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
        case "all":
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
            print("エラーです")
            return [0]
        }
    }
    

}
