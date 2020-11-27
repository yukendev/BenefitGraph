//
//  InitialViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import RealmSwift

class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, toDetailDelegate, tableViewReloadDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var monthArray: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let yearMonthArray = [String]()
//    var sortedBenefitArray = [Benefit]()
    var monthLabelArray = [[Int]]()
//    var cellBenefitArray = [Benefit]()
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "CustomViewCell1", bundle: nil), forCellReuseIdentifier: "CustomCell1")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("viewWillAppear発動")
        getFromRealm()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthLabelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! CustomViewCell1
        
//        cell.cellLabel.text = monthLabelArray[indexPath.row]
        let yearText = String(monthLabelArray[indexPath.row][0])
        let monthText = String(monthLabelArray[indexPath.row][1])
        
        cell.cellLabel.text = yearText + "年 " + monthText + "月"
        
        cell.benefitArray = getCellBenefit(year: yearText, month: monthText)
        
        cell.testText = "テスト"
        
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        cell.noDataLabel.isHidden = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("cellが押されました")
        
        
        toDetail()
    }

    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: nil)
    }
    
    func toDetail() {
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
    func tableViewReload() {
        tableView.reloadData()
        print("成功！")
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddViewController
        nextVC.tableViewReloadDelegate = self
    }
    
    func getFromRealm() {
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
        yearStringArray = yearIntArray.map({ (yearInt: Int) -> String in
            return String(yearInt)
        })
        
        print(yearStringArray)
        sortBenefit(yearArray: yearIntArray)
        
    }
    
    func sortBenefit(yearArray: [Int]) {
        
//        sortedBenefitArray = []
        monthLabelArray = []
    
        
        for year in yearArray {
            let benefitArray = realm.objects(Benefit.self).filter("year == '\(String(year))'")
            for month in monthArray {
                for benefit in benefitArray {
                    if benefit.month == String(month) {
//                        sortedBenefitArray.append(benefit)
                        if monthLabelArray.contains([year, month]){
                            print("重複あり")
                        }else{
                            monthLabelArray.append([year, month])
                        }
                    }
                }
            }
        }
        
        print(monthLabelArray)
    }
    
    
    func arrayFilter(array: [String]) -> [String] {
        let result = NSOrderedSet(array: array)
        let anyArray = result.array
        let resultArray: [String] = anyArray.map {$0 as! String}
          
        return resultArray
    }
    
    func getCellBenefit(year: String, month: String)-> [Benefit] {
        var cellBenefitArray: [Benefit] = []
        let benefitArray = realm.objects(Benefit.self).filter("year == '\(year)' AND month == '\(month)'")
        
        for benefit in benefitArray {
            cellBenefitArray.append(benefit)
        }
        
        print("ガウルぐら")
        print(cellBenefitArray)
        
        return cellBenefitArray
        
    }

}
