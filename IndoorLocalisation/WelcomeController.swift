//
//  WelcomeController.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 09/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedPressed(_ sender: Any) {
        performSegue(withIdentifier: "toBeaconController", sender: nil)
    }
    
    

}
