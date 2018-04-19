//
//  Map.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 19/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//


import UIKit
import Foundation
import CoreLocation


struct BeaconPosition{
    let x : Double
    let y : Double
}

struct MapConstant {
    static let nameKey = "MapName"
    static let position1Key = "position1"
    static let position2Key = "position2"
    static let position3Key = "position3"
    static let roomWidthKey = "roomWidth"
    static let roomHeightKey = "roomHeight"
    static let imageMapKey = "imageMap"
    
}

class Map: NSObject, NSCoding {
    let name: String
    let width : Double
    let height : Double
    let position1 : BeaconPosition
    let position2 : BeaconPosition
    let position3 : BeaconPosition
    
    
    var mapFrame : UIImageView?
    var mapPhoto : UIImage?
    
    
    
    init(name: String, width: Double, height: Double, pos1: BeaconPosition, pos2: BeaconPosition, pos3: BeaconPosition, mapPhoto: UIImage) {
        self.name = name
        self.width = width
        self.height = height
        self.position1 = pos1
        self.position2 = pos2
        self.position3 = pos3
        self.mapPhoto = mapPhoto
        
    }
    
    
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        let aName = aDecoder.decodeObject(forKey: MapConstant.nameKey) as? String
        name = aName ?? ""
        
        width = aDecoder.decodeDouble(forKey: MapConstant.roomWidthKey)
        height = aDecoder.decodeDouble(forKey: MapConstant.roomHeightKey)
        
        let aPos1 = aDecoder.decodeObject(forKey: MapConstant.position1Key) as? BeaconPosition
        position1 = aPos1 ?? BeaconPosition(x: 0, y: 0)
        
        let aPos2 = aDecoder.decodeObject(forKey: MapConstant.position2Key) as? BeaconPosition
        position2 = aPos2 ?? BeaconPosition(x: 0, y: 0)
        
        let aPos3 = aDecoder.decodeObject(forKey: MapConstant.position3Key) as? BeaconPosition
        position3 = aPos3 ?? BeaconPosition(x: 0, y: 0)
        
        let aMapPhoto = aDecoder.decodeObject(forKey: MapConstant.imageMapKey) as? UIImage
        mapPhoto = aMapPhoto ?? UIImage()
        
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: MapConstant.nameKey)
        aCoder.encode(Double(width), forKey: MapConstant.roomWidthKey)
        aCoder.encode(Double(height), forKey: MapConstant.roomHeightKey)
        aCoder.encode(position1, forKey: MapConstant.position1Key)
        aCoder.encode(position2, forKey: MapConstant.position2Key)
        aCoder.encode(position3, forKey: MapConstant.position3Key)
        aCoder.encode(mapPhoto, forKey: MapConstant.imageMapKey)
        
    }
    
}


