//
//  PieChartViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import Charts
import RealmSwift
import GoogleMobileAds

class PieChartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var yearContainer: UIView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    var yearArray = [String]()
    var categoryArray = [String]()
    var benefitArray = [String]()
    var intBenefitArray = [Int]()
    var finalBenefits = [Int]()
    var totalBenefit = Int()
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
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.view.frame.height * 114/896, width: self.view.frame.width, height: 0.5)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        yearContainer.layer.cornerRadius = 10
        
        headerView.layer.addSublayer(bottomLayer)
        
        
        if self.view.safeAreaInsets.top == 0 {
            headerViewHeight.constant = self.view.frame.height * 114/896
        }
        
        noDataLabel.text = "No chart data available"
        noDataLabel.frame = CGRect(x: 0, y: 0, width: 175, height: 30)
        noDataLabel.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/3)
        self.view.addSubview(noDataLabel)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setYearArray()
        
        if yearArray.count == 0 {
            pieChart.isHidden = true
            noDataLabel.isHidden = false
        }else{
            pieChart.isHidden = false
            noDataLabel.isHidden = true
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
        for category in categoryArray {
            benefitArray = []
            intBenefitArray = []
            var finalResult = 0
            let benefitArrayResult = realm.objects(Benefit.self).filter("year == '\(year)' AND category == '\(category)'")
            if benefitArrayResult.count == 0 {
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
        yearPickerView.reloadAllComponents()
    }
    
    func arrayFilter(array: [String]) -> [String] {
        let result = NSOrderedSet(array: array)
        let anyArray = result.array
        let resultArray: [String] = anyArray.map {$0 as! String}
          
        return resultArray
    }
    
}
