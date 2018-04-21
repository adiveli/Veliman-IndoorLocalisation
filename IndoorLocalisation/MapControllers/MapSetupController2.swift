//
//  MapSetupController2.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 19/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit

protocol AddMap {
    func addMap(map: Map)
}


class MapSetupController2: UIViewController {
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var beacon2: UIImageView!
    @IBOutlet weak var beacon3: UIImageView!
    @IBOutlet weak var beacon1: UIImageView!
    @IBOutlet weak var instruction1Label: UILabel!
    @IBOutlet weak var instruction2Label: UILabel!
    @IBOutlet weak var loadButton: UIButton!
    
    @IBOutlet weak var addMapButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    
    var delegate: AddMap?
    
    var width : Double!
    var height : Double!
    var name : String!
    
    var panGesture1 = UIPanGestureRecognizer()
    var panGesture2 = UIPanGestureRecognizer()
    var panGesture3 = UIPanGestureRecognizer()
    
    var step : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapButton.isHidden = true
        heightLabel.text = "\(String(height))"
        widthLabel.text = "\(String(width))"
        
        setGestureRecognizer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMapPressed(_ sender: Any) {
        let name = self.name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let b1Posx = beacon1.center.x
        let b1Posy = beacon1.center.y
        let b2Posx = beacon2.center.x
        let b2Posy = beacon2.center.y
        let b3Posx = beacon3.center.x
        let b3Posy = beacon3.center.y
        
        let newMap = Map(name: name, width: width, height: height, pos1x: b1Posx, pos1y: b1Posy, pos2x: b2Posx, pos2y: b2Posy, pos3x: b3Posx, pos3y: b3Posy, mapPhoto: UIImage())
        
        delegate?.addMap(map: newMap)
        performSegue(withIdentifier: "backToMaps", sender: nil)
    
        
    }
    @IBAction func loadMapPressed(_ sender: Any) {
        print("Sex")
    }
    
    func toMeters(verticalMeters: Double,horizontalMeters: Double,xPos: Double,yPos: Double)->String{
        
        
        let yScale = Double(self.view.frame.height)/verticalMeters
        let xScale = Double(self.view.frame.width)/horizontalMeters
        
        let xMeaning = xPos/xScale
        let yMeaning = yPos/yScale
        
        return "x:\(xMeaning.rounded(toPlaces: 2)) y:\(yMeaning.rounded(toPlaces: 2))"
        
    }
    
    func setGestureRecognizer(){
        
        beacon1.isUserInteractionEnabled = false
        beacon2.isUserInteractionEnabled = false
        beacon3.isUserInteractionEnabled = false
        
        panGesture1 = UIPanGestureRecognizer.init(target: self, action: #selector(moveBeacon))
        panGesture2 = UIPanGestureRecognizer.init(target: self, action: #selector(moveBeacon))
        panGesture3 = UIPanGestureRecognizer.init(target: self, action: #selector(moveBeacon))
        
        panGesture1.minimumNumberOfTouches = 1
        panGesture1.maximumNumberOfTouches = 1
        
        panGesture2.minimumNumberOfTouches = 1
        panGesture2.maximumNumberOfTouches = 1
        
        panGesture3.minimumNumberOfTouches = 1
        panGesture3.maximumNumberOfTouches = 1
        
        beacon1.addGestureRecognizer(panGesture1)
        beacon2.addGestureRecognizer(panGesture2)
        beacon3.addGestureRecognizer(panGesture3)
        self.becomeFirstResponder()
    }
    
 
    
    @objc func moveBeacon(recognizer: UIPanGestureRecognizer) {
     let translation = recognizer.translation(in: self.view)
     if let myView = recognizer.view {
     myView.center = CGPoint(x: myView.center.x + translation.x, y: myView.center.y + translation.y)
        positionLabel.text = toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(myView.center.x), yPos: Double(myView.center.y))
     }
        
        
     recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
     }

    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake && step == 0{
            step = step + 1
            beacon1.isUserInteractionEnabled = true
            instruction1Label.fadeOut()
            instruction2Label.fadeOut()
            loadButton.fadeOut()
            beacon2.fadeOut()
            beacon3.fadeOut()
        }else if motion == .motionShake && step == 1{
            step = step + 1
            beacon1.isUserInteractionEnabled = false
            beacon2.isUserInteractionEnabled = true
            beacon2.fadeIn()
        }else if motion == .motionShake && step == 2{
            step = step + 1
            beacon2.isUserInteractionEnabled = false
            beacon3.isUserInteractionEnabled = true
            beacon3.fadeIn()
        }else if motion == .motionShake && step == 3{
            step = step + 1
            addMapButton.fadeOut()
            addMapButton.isHidden = false
            addMapButton.fadeIn()
            positionLabel.fadeOut()
            beacon3.isUserInteractionEnabled = false
        }

    }
    
    
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
