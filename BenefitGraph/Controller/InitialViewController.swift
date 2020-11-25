//
//  InitialViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit

class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, toDetailDelegate, tableViewReloadDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    let exampleArray: [String] = ["2020年 10月", "2020年 11月", "2020年 12月"]
    
    

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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! CustomViewCell1
        
        cell.cellLabel.text = exampleArray[indexPath.row]
        
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
    
    
    
    
    
    
    

}
