//
//  KnownMapsController.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 19/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit


let storedMapsKey = "storedMaps"

class KnownMapsController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var maps = [Map]()
    var items = [Item]()
    
    var selectedCell : Int?
    var lastSelection: NSIndexPath!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItems()
        for map in maps{
            print(map)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMapPressed(_ sender: Any) {
        performSegue(withIdentifier: "toMapSetup1", sender: nil)
    }
    
    @IBAction func startLocalisationPressed(_ sender: Any) {
        if(selectedCell != nil){
            performSegue(withIdentifier: "toLocalizationController", sender: nil)
        }else{
            let detailAlert = UIAlertController(title: "Error", message: "You need to select a map!", preferredStyle: .alert)
            detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(detailAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "toBeacons", sender: nil)
    }
    
    func getItems() {
        guard let storedItems = UserDefaults.standard.array(forKey: storedMapsKey) as? [Data] else { return }
        for itemData in storedItems {
            guard let map = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Map else { continue }
            maps.append(map)
            
        }
    }
    
    func saveItems() {
        var itemsData = [Data]()
        for map in maps {
            let itemData = NSKeyedArchiver.archivedData(withRootObject: map)
            itemsData.append(itemData)
        }
        UserDefaults.standard.set(itemsData, forKey: storedMapsKey)
        UserDefaults.standard.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapSetup1", let viewController = segue.destination as? MapSetupController1 {
            viewController.dl = self
            viewController.items = self.items
        }
        
        if segue.identifier == "toLocalizationController", let viewController = segue.destination as? LocalisationController {
            viewController.chosenMap = maps[selectedCell!]
            viewController.items = self.items
        }
        
    }
    
    
    
}

extension KnownMapsController: AddMap {
    func addMap(map: Map) {
        maps.append(map)
        
        tableView.beginUpdates()
        let newIndexPath = IndexPath(row: maps.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.endUpdates()
        
        saveItems()
    }
    
}


extension KnownMapsController : UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
        cell.map = maps[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maps.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            maps.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            saveItems()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}


extension KnownMapsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.lastSelection != nil {
            self.tableView.cellForRow(at: self.lastSelection as IndexPath)?.accessoryType = .none
        }
        
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        self.lastSelection = indexPath as NSIndexPath
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    
        selectedCell = indexPath.row
        let map = maps[indexPath.row]
        let detailMessage = "Width: \(map.width)\nHeight: \(map.height)"
        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(detailAlert, animated: true, completion: nil)
    }
    
    
}


