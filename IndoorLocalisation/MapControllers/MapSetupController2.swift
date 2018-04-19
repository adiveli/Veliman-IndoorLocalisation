//
//  MapSetupController2.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 19/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit

class MapSetupController2: UIViewController {
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var beacon2: UIImageView!
    @IBOutlet weak var beacon3: UIImageView!
    @IBOutlet weak var beacon1: UIImageView!
    
    var width : Double!
    var height : Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        heightLabel.text = "\(String(height))"
        widthLabel.text = "\(String(width))"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadMapPressed(_ sender: Any) {
        print("Sex")
    }
    
    
}
