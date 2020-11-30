//
//  LineGraphViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit
import Charts




class LineGraphViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    
    let months: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let benefits: [Double] = [12, 14, 2778, 59, 49, 35090, 12, 3432, 43, 243, 123, 126]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLineGraph()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func setLineGraph(){
        var entry = [ChartDataEntry]()
        
        for (i,d) in benefits.enumerated(){
            entry.append(ChartDataEntry(x: months[i],y: d))
        }
        
        let dataset = LineChartDataSet(entries: entry,label: "Units Sold")
                
        lineChart.data = LineChartData(dataSet: dataset)
        lineChart.chartDescription?.text = "Item Sold Chart"
    }
    

}
