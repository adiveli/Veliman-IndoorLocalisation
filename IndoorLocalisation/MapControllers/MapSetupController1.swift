//
//  MapSetupController1.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 19/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit

class MapSetupController1: UIViewController {

    @IBOutlet weak var roomNameField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var widthField: UITextField!
    
    var roomName : String = ""
    var roomWidth : Double = 0.0
    var roomHeight : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        roomName = roomNameField.text!
        if let width = Double(widthField.text!), let height = Double(heightField.text!), roomName != ""{
            roomWidth = width
            roomHeight = height
            performSegue(withIdentifier: "toMapSetup2", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Incorect parameters for width or height, or no name inserted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss keyboard
        self.view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapSetup2", let viewController = segue.destination as? MapSetupController2 {
            viewController.height = roomHeight
            viewController.width = roomWidth
            //viewController.delegate = self
        }
    }
    
}
