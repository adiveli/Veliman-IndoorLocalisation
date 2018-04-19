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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMapPressed(_ sender: Any) {
        performSegue(withIdentifier: "toMapSetup1", sender: nil)
    }
    
    @IBAction func startLocalisationPressed(_ sender: Any) {
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func loadItems() {
        guard let storedItems = UserDefaults.standard.array(forKey: storedMapsKey) as? [Data] else { return }
        for itemData in storedItems {
            guard let map = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Map else { continue }
            maps.append(map)
            
        }
    }
    
    func persistItems() {
        var itemsData = [Data]()
        for map in maps {
            let itemData = NSKeyedArchiver.archivedData(withRootObject: map)
            itemsData.append(itemData)
        }
        UserDefaults.standard.set(itemsData, forKey: storedMapsKey)
        UserDefaults.standard.synchronize()
    }
    
    
    
}

/*extension KnownMapsController: AddMap {
    func addMap(map: Map) {
        maps.append(map)
        
        tableView.beginUpdates()
        let newIndexPath = IndexPath(row: maps.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.endUpdates()
        
        persistItems()
    }
    
}*/


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
            persistItems()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}


extension KnownMapsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let map = maps[indexPath.row]
        let detailMessage = "Width: \(map.width)\nHeight: \(map.height))"
        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(detailAlert, animated: true, completion: nil)
    }
}


