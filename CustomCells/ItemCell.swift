//
//  ItemCell.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 09/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    
    var item: Item? = nil {
        didSet {
            if let item = item {
                nameLabel.text = item.name
                locationLabel.text = item.locationString()
                
            } else {
                nameLabel.text = ""
                locationLabel.text = ""
            }
        }
    }
    
    func refreshLocation() {
        locationLabel.text = item?.locationString() ?? ""
    }

}
