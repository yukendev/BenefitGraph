//
//  LineGraphViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import Charts
import RealmSwift
import GoogleMobileAds




class LineGraphViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var yearContainer: UIView!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var benefitLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categoryContainerBottom: NSLayoutConstraint!
    @IBOutlet weak var yearContainerBottom: NSLayoutConstraint!
    
    
    let months: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let monthsString: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var benefits: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var year = String()
    var category = String()
    
    var yearArray = [String]()
    var categoryArray = [String]()
    
    let noDataLabel = UILabel()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        if self.view.frame.height <= 700 {
            gadBannerView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 65)
        }else{
            gadBannerView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 105)
        }
        gadBannerView.adUnitID = "ca-app-pub-7065554389714042/5471310181"
        gadBannerView.rootViewController = self
        let request = GADRequest()
        gadBannerView.load(request)
        self.view.addSubview(gadBannerView)
        
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        yearContainer.layer.cornerRadius = 10
        categoryContainer.layer.cornerRadius = 10
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.view.frame.height * 114/896, width: self.view.frame.width, height: 0.5)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        
        headerView.layer.addSublayer(bottomLayer)
        
        if self.view.frame.height >= 700 {
            categoryContainerBottom.constant = 50
            yearContainerBottom.constant = 50
        }else{
            categoryContainerBottom.constant = 20
            yearContainerBottom.constant = 20
            headerViewHeight.constant = self.view.frame.height * 114/896
        }
        
        
        noDataLabel.text = "No chart data available"
        noDataLabel.frame = CGRect(x: 0, y: 0, width: 175, height: 30)
        noDataLabel.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/3)
        self.view.addSubview(noDataLabel)
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        getYearAndCategory()
        
        if yearArray.count == 0 {
            benefitLabel.text = "データなし"
            lineChart.isHidden = true
            noDataLabel.isHidden = false
            
        }else{
            lineChart.isHidden = false
            noDataLabel.isHidden = true
            category = categoryArray[0]
            year = yearArray[yearArray.count - 1]
            
            reloadGraph(category: category, year: Int(year)!)
            benefitLabel.text = "\(getAllBenefit(year: year))" + "円"
            
            yearPickerView.selectRow(yearArray.count - 1, inComponent: 0, animated: true)
            categoryPickerView.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func setLineGraph(label: String){
        var entry = [ChartDataEntry]()
        
        for (i,d) in benefits.enumerated(){
            entry.append(ChartDataEntry(x: Double(i),y: Double(d)))
        }
        
        let dataset = LineChartDataSet(entries: entry,label: label)
        dataset.valueFormatter = LineChartValueFormatter()
        dataset.valueFont = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        formatter.minimumFractionDigits = 0
        lineChart.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
                
        lineChart.data = LineChartData(dataSet: dataset)
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
        lineChart.dragEnabled = false
        
        
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelCount = Int(11)
        lineChart.xAxis.axisLineWidth = CGFloat(2)
        lineChart.xAxis.valueFormatter = LineChartFormatter()
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 11)
        
        //yの最低値を0に設定
        lineChart.rightAxis.axisMinimum = 0.0
        lineChart.leftAxis.axisMinimum = 0.0

        //y軸のラベルを整数値にする処理。
        lineChart.rightAxis.granularityEnabled = true
        lineChart.leftAxis.granularityEnabled = true
        lineChart.rightAxis.granularity = 1.0
        lineChart.leftAxis.granularity = 1.0
        lineChart.leftAxis.axisLineWidth = CGFloat(2)
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
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
                }
            }
            return allBenefits
        default:
            var allBenefits = [Int]()
            for month in monthsString {
                let monthCategoryBenefit = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)' AND category == '\(category)'")
                if monthCategoryBenefit.count == 0 {
                    allBenefits.append(0)
                }else{
                    var stringBenefit = String()
                    for benefit in monthCategoryBenefit {
                        stringBenefit = benefit.benefit!
                    }
                    allBenefits.append(Int(stringBenefit)!)
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
            if yearArray.count != 0 {
                return yearArray.count
            }else{
                return 1
            }
        case 1:
            if yearArray.count != 0 {
                return categoryArray.count
            }else{
                return 1
            }
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            if yearArray.count != 0 {
                return yearArray[row]
            }else{
                return "データなし"
            }
        case 1:
            if yearArray.count != 0 {
                return categoryArray[row]
            }else{
                return "データなし"
            }
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            if yearArray.count != 0 {
                year = yearArray[row]
                reloadGraph(category: category, year: Int(year)!)
                benefitLabel.text = "\(getAllBenefit(year: year))" + "円"
            }else{
                print("データなし")
            }
        case 1:
            if yearArray.count != 0 {
                category = categoryArray[row]
                reloadGraph(category: category, year: Int(year)!)
            }else{
                print("データなし")
            }
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
        
        setLineGraph(label: category)
    }
    
    func getAllBenefit(year: String) -> Int {
        let yearBenefits = realm.objects(Benefit.self).filter("year == '\(year)'")
        var stringBenefits = [String]()
        for benefit in yearBenefits {
            stringBenefits.append(benefit.benefit!)
        }
        var intBenefits = [Int]()
        for stringBenefit in stringBenefits {
            intBenefits.append(Int(stringBenefit)!)
        }
        var result: Int = 0
        for intBenefit in intBenefits {
            result += intBenefit
        }
        return result
    }
    
    

}

public class LineChartValueFormatter: NSObject, IValueFormatter{
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String{
        return String(Int(entry.y))
    }
}

public class LineChartFormatter: NSObject, IAxisValueFormatter{
    var months: [String]! = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}
