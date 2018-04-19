//
//  AddNewBeaconController.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 09/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit

protocol AddBeacon {
    func addBeacon(item: Item)
}

class AddNewBeaconController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var uuidField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var minorField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var calibrateBtn: UIButton!
    
    @IBOutlet weak var infoBtn: UIButton!
    
    let uuidRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
    
    var delegate: AddBeacon?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.isEnabled = false
        calibrateBtn.isEnabled = false
        infoBtn.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss keyboard
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func infoPressed(_ sender: Any) {
        performSegue(withIdentifier: "toInfoController", sender: 0 as Int)
    }
    
    @IBAction func calibratePressed(_ sender: Any) {
        performSegue(withIdentifier: "toInfoController", sender: 1 as Int)
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        // Create new beacon item
        let uuidString = uuidField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let uuid = UUID(uuidString: uuidString) else { return }
        let major = Int(majorField.text!) ?? 0
        let minor = Int(minorField.text!) ?? 0
        let name = nameField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let newItem = Item(name: name, uuid: uuid, majorValue: major, minorValue: minor)
        
        delegate?.addBeacon(item: newItem)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        // Is name valid?
        let nameValid = (nameField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count > 0)
        
        
        // Is UUID valid?
        var uuidValid = false
        let uuidString = uuidField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if uuidString.characters.count > 0 {
            uuidValid = (uuidRegex.numberOfMatches(in: uuidString, options: [], range: NSMakeRange(0, uuidString.characters.count)) > 0)
        }
        uuidField.textColor = (uuidValid) ? .black : .red
        
        // Toggle btnAdd enabled based on valid user entry
        addButton.isEnabled = (nameValid && uuidValid)
        calibrateBtn.isEnabled = (nameValid && uuidValid)
        infoBtn.isEnabled = (nameValid && uuidValid)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toInfoController"){
            if let infoController = segue.destination as? InfoController{
                infoController.trigger = sender as! Int
                infoController.currentUUID = UUID(uuidString: uuidField.text!)!
                infoController.major = majorField.text!
                infoController.minor = minorField.text!
                infoController.name = nameField.text!
                //infoController.scrollView.setContentOffset(point, animated: true)
            }
        }
    }
    

}

extension AddNewBeaconController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Enter key hides keyboard
        textField.resignFirstResponder()
        return true
    }
}
