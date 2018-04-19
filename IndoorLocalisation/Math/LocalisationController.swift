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
    
    var items = [Item]()
    
    let locationManager = CLLocationManager()
    
    var personIcon : UIImage!
    var personPositionIcon : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personIcon = UIImage(named: "personIcon")
        personPositionIcon = UIImageView(image: personIcon)
        //positionBeacons()
        positionItems()
        
        
        let date = Date().addingTimeInterval(1)
        let timer2 = Timer(fireAt: date, interval: 0.5, target: self, selector: #selector(locateContinuoss), userInfo: nil, repeats: true)
        RunLoop.main.add(timer2, forMode: RunLoopMode.commonModes)
        
        

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    /*func positionBeacons(){ ///to be readapted
        
        b1.frame.origin.y = toPixels(xPosition: 0.5, yPosition: 3, verticalMeters: 5, horizontalMeters: 4)[0]
        
        b1.frame.origin.x = toPixels(xPosition: 0.5, yPosition: 3, verticalMeters: 5, horizontalMeters: 4)[1]
        
        b2.frame.origin.y = toPixels(xPosition: 4, yPosition: 3.5, verticalMeters: 5, horizontalMeters: 4)[0]
        b2.frame.origin.x = toPixels(xPosition: 4, yPosition: 3.5, verticalMeters: 5, horizontalMeters: 4)[1]
        
        b3.frame.origin.y = toPixels(xPosition: 2.5, yPosition: 0.3, verticalMeters: 5, horizontalMeters: 4)[0]
        b3.frame.origin.x = toPixels(xPosition: 2.5, yPosition: 0.3, verticalMeters: 5, horizontalMeters: 4)[1]
        
    }*/
    
    func positionItems(){
        
        let beaconIcon = UIImage(named: "beaconIcon")
        
        let b1 = toPixels(xPosition: 0.1, yPosition: 1, verticalMeters: 4.6, horizontalMeters: 3.1)
        let b2 = toPixels(xPosition: 2, yPosition: 4.4, verticalMeters: 4.6, horizontalMeters: 3.1)
        let b3 = toPixels(xPosition: 2.9, yPosition: 0.1, verticalMeters: 4.6, horizontalMeters: 3.1)
        
        
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
        let p1 = Point(xx: 0.1, yy: 1)
        let p2 = Point(xx: 2, yy: 4.4)
        let p3 = Point(xx: 2.9, yy: 0.1)
        
        var r1 : Double = 0
        var r2 : Double = 0
        var r3 : Double = 0
        
        if items[0].name == "2"{
            r1 = (items[0].beacon?.accuracy)!
        }
        if items[1].name == "1"{
            r2 = (items[1].beacon?.accuracy)!
        }
        if items[2].name == "3"{
            r3 = (items[2].beacon?.accuracy)!
        }
        
        
        /*let r1:Double = (items[0].beacon?.accuracy)!
        let r2:Double = (items[1].beacon?.accuracy)!
        let r3:Double = (items[2].beacon?.accuracy)!*/
        
        location = Utilities.trilateration(point1: p1, point2: p2, point3: p3, r1: r1, r2: r2, r3: r3)
        
        var scalingFactors = toMeters(verticalMeters: 4.5, horizontalMeters: 3.1)
        
        distance1.text = "2:\(items[0].beacon?.accuracy)"
        distance2.text = "1:\(items[1].beacon?.accuracy)"
        distance3.text = "3:\(items[2].beacon?.accuracy)"
        
        rezultatMLabel.text = "x: \(Double((location?.x)!)) y: \(Double((location?.y)!))"
        
        var personXPosition = CGFloat(((location?.x)!)*scalingFactors[0])
        var personYPosition = CGFloat(((location?.y)!)*scalingFactors[1])
        
        
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
        
        
        
        
        rezultatPiexeliLabel.text = "x:\(personXPosition) y: \(personYPosition)"
        
        personPositionIcon.frame = CGRect(x: personXPosition, y: personYPosition, width: 20, height: 40)
        self.view.addSubview(personPositionIcon)
    
    }
    
    
    @objc func locateContinous(){
        
        let solver = MatrixSolver()
        
        
        
        var c1 = Double()
        var c2 = Double()
        var c3 = Double()
        var c4 = Double()
        var coef1 = Double()
        var coef2 = Double()
        
        let x1 : Double = 0.1
        let x2 : Double = 3
        let x3 : Double = 1.5
        let y1 : Double = 0.1
        let y2 : Double = 1
        let y3 : Double = 3.8
        
        var d1 : Double = 0
        var d2 : Double = 0
        var d3 : Double = 0
        
        
        
        if items[0].name == "2"{
            d2 = (items[1].beacon?.accuracy)!
        }
        if items[1].name == "1"{
            d1 = (items[0].beacon?.accuracy)!
        }
        if items[2].name == "3"{
            d3 = (items[2].beacon?.accuracy)!
        }
        
        
        
        
       
        
        c1 = 2 * (x3 - x1)
        c2 = 2 * (y3 - y1)
        c3 = 2 * (x3 - x2)
        c4 = 2 * (y3 - y2)
        coef1 = -(x1*x1) - (y1*y1) + (x3*x3) + (y3*y3) + (d1*d1) - (d3*d3)
        coef2 = -(x2*x2) - (y2*y2) + (x3*x3) + (y3*y3) + (d2*d2) - (d3*d3)
        
        
        var personPosition = solver.solve(A: [c1,c2,c3,c4], b: [coef1,coef2])
        
        rezultatMLabel.text = "\(personPosition)"
        var scalingFactors = toMeters(verticalMeters: 4.1, horizontalMeters: 3.1)
        
        print(scalingFactors)
        
        var personXPosition = CGFloat(personPosition[0]*scalingFactors[1])
        var personYPosition = CGFloat(personPosition[1]*scalingFactors[0])
        
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
        
        
        distance1.text = "2:\(items[0].beacon?.accuracy)"
        distance2.text = "1:\(items[1].beacon?.accuracy)"
        distance3.text = "3:\(items[2].beacon?.accuracy)"
        
        print("x: \(personXPosition)")
        print("y: \(personYPosition)")
        rezultatPiexeliLabel.text = "x:\(personXPosition) y: \(personYPosition)"
        
        personPositionIcon.frame = CGRect(x: personXPosition, y: personYPosition, width: 20, height: 40)
        self.view.addSubview(personPositionIcon)
        
        
        
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

