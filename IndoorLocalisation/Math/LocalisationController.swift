//
//  LocalisationController.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 15/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit
import CoreLocation


class LocalisationController: UIViewController {
    
    @IBOutlet weak var distance1: UILabel!
    @IBOutlet weak var distance2: UILabel!
    @IBOutlet weak var distance3: UILabel!
    @IBOutlet weak var rezultatMLabel: UILabel!
    @IBOutlet weak var rezultatPiexeliLabel: UILabel!
    
    @IBOutlet weak var mapImage: UIImageView!
    
    var items = [Item]()
    
    var chosenMap : Map?
    
    let locationManager = CLLocationManager()
    
    var personIcon : UIImage!
    var personPositionIcon : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personIcon = UIImage(named: "personIcon")
        personPositionIcon = UIImageView(image: personIcon)
        mapImage.image = chosenMap?.mapPhoto
        positionItems()
        
        
        
        
        let date = Date().addingTimeInterval(1)
        let timer2 = Timer(fireAt: date, interval: 0.2, target: self, selector: #selector(locateContinuoss), userInfo: nil, repeats: true)
        RunLoop.main.add(timer2, forMode: RunLoopMode.commonModes)
        
        

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //return scaling factors
    func toMeters(verticalMeters: Double,horizontalMeters: Double)->[Double]{
        

        let yScale = Double(self.view.frame.height)/verticalMeters
        let xScale = Double(self.view.frame.width)/horizontalMeters
    
        return [yScale,xScale]
        
    }
    
    
    
    func toPixels(xPosition: Double,yPosition: Double,verticalMeters: Double,horizontalMeters: Double)->[CGFloat]{
        
        var scalingFactors = toMeters(verticalMeters: verticalMeters, horizontalMeters: horizontalMeters)
        
        
        
        let yValueCGF = CGFloat(yPosition*scalingFactors[0])-20
        let xValueCGF = CGFloat(xPosition*scalingFactors[1])-20
        
        
        return [yValueCGF,xValueCGF]
        
    }
    
    
    func positionItems(){
        
        let beaconIcon = UIImage(named: "beaconIcon")
        
        let b1 = toPixels(xPosition: Double((chosenMap?.position1x)!), yPosition: Double((chosenMap?.position1y)!), verticalMeters: (chosenMap?.height)!, horizontalMeters: (chosenMap?.width)!)
        let b2 = toPixels(xPosition: Double((chosenMap?.position2x)!), yPosition: Double((chosenMap?.position2y)!), verticalMeters: (chosenMap?.height)!, horizontalMeters: (chosenMap?.width)!)
        let b3 = toPixels(xPosition: Double((chosenMap?.position3x)!), yPosition: Double((chosenMap?.position3y)!), verticalMeters: (chosenMap?.height)!, horizontalMeters: (chosenMap?.width)!)
        
        
        items[1].icon = UIImageView(frame: CGRect(x:b1[1] , y: b1[0], width: 40, height: 40))
        items[0].icon = UIImageView(frame: CGRect(x:b2[1] , y: b2[0], width: 40, height: 40))
        items[2].icon = UIImageView(frame: CGRect(x:b3[1] , y: b3[0], width: 40, height: 40))
        items[0].icon?.image = beaconIcon
        items[1].icon?.image = beaconIcon
        items[2].icon?.image = beaconIcon
        self.view.addSubview(items[0].icon!)
        self.view.addSubview(items[1].icon!)
        self.view.addSubview(items[2].icon!)
        
        
    }
    
    
    
    @objc func locateContinuoss(){
        
        var location:Point?
        let p1 = Point(xx: Double((chosenMap?.position1x)!), yy: Double((chosenMap?.position1y)!))
        let p2 = Point(xx: Double((chosenMap?.position2x)!), yy: Double((chosenMap?.position2y)!))
        let p3 = Point(xx: Double((chosenMap?.position3x)!), yy: Double((chosenMap?.position3y)!))
        
        var r1 : Double = 0
        var r2 : Double = 0
        var r3 : Double = 0
        
        
        
        if let valoare0 = (items[0].beacon?.accuracy),items[0].name == "2"{
            r1 = valoare0
        }
        if let valoare1 = (items[1].beacon?.accuracy),items[1].name == "1"{
            r2 = valoare1

        }
        if let valoare2 = (items[2].beacon?.accuracy),items[2].name == "3"{
            r3 = valoare2
        }
        
        
        //get values in meters
        location = Utilities.trilateration(point1: p1, point2: p2, point3: p3, r1: r1, r2: r2, r3: r3)
        
        
        //get scaling factors for transforming distance in pixels
        var scalingFactors = toMeters(verticalMeters: (chosenMap?.height)!, horizontalMeters: (chosenMap?.width)!)
        
        distance1.text = ""
        distance2.text = ""
        distance3.text = ""
        
        
        //get coordinates in pixel by using scaling factor * value in meters
        var personXPosition = CGFloat(((location?.x)!)*scalingFactors[1])
        var personYPosition = CGFloat(((location?.y)!)*scalingFactors[0])
        
        
        
        //assure that path doesn't get over the accepted zone
        if(personYPosition > 660){
            personYPosition = 660
        }
        else if(personYPosition < 10){
            personYPosition = 10
        }
        else if(personXPosition > 365){
            personXPosition = 365
        }
        else if(personXPosition < 10){
            personXPosition = 10
        }

        
        //set position
        personPositionIcon.frame = CGRect(x: personXPosition, y: personYPosition, width: 20, height: 40)
        self.view.addSubview(personPositionIcon)
    
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            
            performSegue(withIdentifier: "toMaps", sender: nil)
            
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMaps"){
            if let viewController = segue.destination as? KnownMapsController{
                viewController.items = self.items
            }
        }
    }
    

    
}


extension LocalisationController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        // Find the same beacons in the table.
        var indexPaths = [IndexPath]()
        for beacon in beacons {
            //print(beacon)
            for row in 0..<items.count {
                if items[row] == beacon {
                    items[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                }
            }
        }
        
        
    }
    
    
}

