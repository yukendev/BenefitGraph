//
//  LineGraphViewController.swift
//  BenefitGraph
//
//  Created by 手塚友健 on 2020/11/22.
//

import UIKit

class LineGraphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    
    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: nil)
    }
    

}
