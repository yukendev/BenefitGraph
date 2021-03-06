//
//  InitialViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, toDetailDelegate, tableViewReloadDelegate {
    

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    var monthArray: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let yearMonthArray = [String]()
    var monthLabelArray = [[Int]]()
    var detailYear = String()
    var detailMonth = String()
    let noDataLabel = UILabel()
    let realm = try! Realm()
    let refreshCtl = UIRefreshControl()
    

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
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "CustomViewCell1", bundle: nil), forCellReuseIdentifier: "CustomCell1")
        
        tableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(self.refreshTable), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshCtl
        
        addButton.adjustsImageWhenHighlighted = false
        addButton.addTarget(self, action: #selector(self.pushButton_Animation(_:)), for: .touchDown)
        addButton.addTarget(self, action: #selector(self.separateButton_Animation(_:)), for: .touchUpInside)
        
        noDataLabel.text = "記録がありません"
        noDataLabel.font = noDataLabel.font.withSize(20)
        noDataLabel.frame = CGRect(x:50,y:50,width: 250,height:250)
        noDataLabel.textAlignment = .center
        noDataLabel.center = self.view.center
        self.view.addSubview(noDataLabel)
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.view.frame.height * 114/896, width: self.view.frame.width, height: 0.5)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        
        headerView.layer.addSublayer(bottomLayer)
        
        if self.view.frame.height <= 700 {
            headerViewHeight.constant = self.view.frame.height * 114/896
        }
        
        
        
    }
    
    @objc func refreshTable() {
        refreshCtl.endRefreshing()
        tableView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFromRealm()
        noDataLabelisHidden()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthLabelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! CustomViewCell1

        let yearText = String(monthLabelArray[indexPath.row][0])
        let monthText = String(monthLabelArray[indexPath.row][1])
        
        cell.cellLabel.text = yearText + "年 " + monthText + "月"
        
        let benefitArray = getCellBenefit(year: yearText, month: monthText)
        
        cell.categoryArray = []
        cell.moneyArray = []
        
        for benefit in benefitArray {
            cell.categoryArray.append(benefit.category!)
            cell.moneyArray.append(benefit.benefit!)
        }
        
        cell.year = yearText
        
        cell.month = monthText
        
        cell.tableView.reloadData()
        
        cell.backgroundColor = UIColor.clear
        
        
        cell.selectionStyle = .none
        
        cell.setHeight()
        
        cell.delegate = self
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDetail(year: String(monthLabelArray[indexPath.row][0]), month: String(monthLabelArray[indexPath.row][1]))
    }

    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: nil)
    }
    
    func toDetail(year: String, month: String) {
        detailYear = year
        detailMonth = month
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
    func tableViewReload() {
        getFromRealm()
        noDataLabelisHidden()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            let nextVC = segue.destination as! AddViewController
            nextVC.tableViewReloadDelegate = self
        }else if segue.identifier == "detail" {
            let nextVC = segue.destination as! DetailViewController
            nextVC.year = detailYear
            nextVC.month = detailMonth
        }
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
        sortBenefit(yearArray: yearIntArray)
        
    }
    
    func sortBenefit(yearArray: [Int]) {
        
        monthLabelArray = []
        
        for year in yearArray {
            let benefitArray = realm.objects(Benefit.self).filter("year == '\(String(year))'")
            for month in monthArray {
                for benefit in benefitArray {
                    if benefit.month == String(month) {
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
        monthLabelArray.reverse()
        tableView.reloadData()
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
        
        return cellBenefitArray
        
    }
    
    func noDataLabelisHidden() {
        if monthLabelArray.count == 0 {
            noDataLabel.isHidden = false
        }else{
            noDataLabel.isHidden = true
        }
    }

}
