//
//  MapCell.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 19/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit

class MapCell: UITableViewCell {

    @IBOutlet weak var mapNameLabel: UILabel!
    
    var map: Map? = nil {
        didSet {
            if let map = map {
                mapNameLabel.text = map.name
            } else {
                mapNameLabel.text = ""
            }
        }
    }
}
