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



struct MapConstant {
    static let nameKey = "MapName"
    static let position1xKey = "position1x"
    static let position1yKey = "position1y"
    static let position2xKey = "position2x"
    static let position2yKey = "position2y"
    static let position3xKey = "position3x"
    static let position3yKey = "position3y"
    static let roomWidthKey = "roomWidth"
    static let roomHeightKey = "roomHeight"
    static let imageMapKey = "imageMap"
    
}

class Map: NSObject, NSCoding {
    let name: String
    let width : Double
    let height : Double
    let position1x : CGFloat
    let position1y : CGFloat
    let position2x : CGFloat
    let position2y : CGFloat
    let position3x : CGFloat
    let position3y : CGFloat
    
    
    var mapFrame : UIImageView?
    var mapPhoto : UIImage?
    
    
    
    init(name: String, width: Double, height: Double, pos1x: CGFloat ,pos1y:CGFloat, pos2x: CGFloat,pos2y: CGFloat, pos3x: CGFloat,pos3y:CGFloat, mapPhoto: UIImage?) {
        self.name = name
        self.width = width
        self.height = height
        self.position1x = pos1x
        self.position1y = pos1y
        self.position2x = pos2x
        self.position2y = pos2y
        self.position3x = pos3x
        self.position3y = pos3y
        self.mapPhoto = mapPhoto ?? UIImage()
        
    }
    
    
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        let aName = aDecoder.decodeObject(forKey: MapConstant.nameKey) as? String
        name = aName ?? ""
        
        width = aDecoder.decodeDouble(forKey: MapConstant.roomWidthKey)
        height = aDecoder.decodeDouble(forKey: MapConstant.roomHeightKey)
        
        let aPos1x = aDecoder.decodeObject(forKey: MapConstant.position1xKey) as? CGFloat
        position1x = aPos1x ?? 0.0
        
        let aPos1y = aDecoder.decodeObject(forKey: MapConstant.position1yKey) as? CGFloat
        position1y = aPos1y ?? 0.0
        
        let aPos2x = aDecoder.decodeObject(forKey: MapConstant.position2xKey) as? CGFloat
        position2x = aPos2x ?? 0.0
        
        let aPos2y = aDecoder.decodeObject(forKey: MapConstant.position2yKey) as? CGFloat
        position2y = aPos2y ?? 0.0
        
        let aPos3x = aDecoder.decodeObject(forKey: MapConstant.position3xKey) as? CGFloat
        position3x = aPos3x ?? 0.0
        
        let aPos3y = aDecoder.decodeObject(forKey: MapConstant.position3yKey) as? CGFloat
        position3y = aPos3y ?? 0.0
        
        let aMapPhoto = aDecoder.decodeObject(forKey: MapConstant.imageMapKey) as? UIImage
        mapPhoto = aMapPhoto ?? UIImage()
        
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: MapConstant.nameKey)
        aCoder.encode(Double(width), forKey: MapConstant.roomWidthKey)
        aCoder.encode(Double(height), forKey: MapConstant.roomHeightKey)
        aCoder.encode(position1x, forKey: MapConstant.position1xKey)
        aCoder.encode(position1y, forKey: MapConstant.position1yKey)
        aCoder.encode(position2x, forKey: MapConstant.position2xKey)
        aCoder.encode(position2y, forKey: MapConstant.position2yKey)
        aCoder.encode(position3x, forKey: MapConstant.position3xKey)
        aCoder.encode(position3y, forKey: MapConstant.position3yKey)
        aCoder.encode(mapPhoto, forKey: MapConstant.imageMapKey)
        
    }
    
}


