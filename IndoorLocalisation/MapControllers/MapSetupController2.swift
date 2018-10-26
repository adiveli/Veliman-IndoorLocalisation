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


class MapSetupController2: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var beacon2: UIImageView!
    @IBOutlet weak var beacon3: UIImageView!
    @IBOutlet weak var beacon1: UIImageView!
    @IBOutlet weak var instruction1Label: UILabel!
    @IBOutlet weak var instruction2Label: UILabel!
    @IBOutlet weak var loadButton: UIButton!
    
    @IBOutlet weak var mapImage: UIImageView!
    
    @IBOutlet weak var addMapButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    
    var items = [Item]()
    
    var delegate: AddMap?
    
    var width : Double!
    var height : Double!
    var name : String!
    
    var panGesture1 = UIPanGestureRecognizer()
    var panGesture2 = UIPanGestureRecognizer()
    var panGesture3 = UIPanGestureRecognizer()
    
    var step : Int = 0
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapButton.isHidden = true
        heightLabel.text = "\(String(height))"
        widthLabel.text = "\(String(width))"
        imagePicker.delegate = self
        
        setGestureRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //keep position of beacons in pixels
    @IBAction func addMapPressed(_ sender: Any) {
        let name = self.name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let b1Posx = toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(beacon1.center.x), yPos: Double(beacon1.center.y))[0]
        let b1Posy = toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(beacon1.center.x), yPos: Double(beacon1.center.y))[1]
        let b2Posx = toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(beacon2.center.x), yPos: Double(beacon2.center.y))[0]
        let b2Posy = toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(beacon2.center.x), yPos: Double(beacon2.center.y))[1]
        let b3Posx = toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(beacon3.center.x), yPos: Double(beacon3.center.y))[0]
        let b3Posy = toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(beacon3.center.x), yPos: Double(beacon3.center.y))[1]
        
        print(beacon1.center.x)
        print(beacon1.center.y)
        
        let newMap = Map(name: name, width: width, height: height, pos1x: CGFloat(b1Posx), pos1y: CGFloat(b1Posy), pos2x: CGFloat(b2Posx), pos2y: CGFloat(b2Posy), pos3x: CGFloat(b3Posx), pos3y: CGFloat(b3Posy), mapPhoto: mapImage.image)
        
        delegate?.addMap(map: newMap)
        performSegue(withIdentifier: "backToMaps", sender: nil)
    
        
    }
    @IBAction func loadMapPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            print("Button capture")
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    //pixel -> meter -- based on description of map
    func toMeters(verticalMeters: Double,horizontalMeters: Double,xPos: Double,yPos: Double)->[Double]{
        
        
        let yScale = Double(self.view.frame.height)/verticalMeters
        let xScale = Double(self.view.frame.width)/horizontalMeters
        
        let xMeaning = xPos/xScale
        let yMeaning = yPos/yScale
        
        return [xMeaning.rounded(toPlaces: 2), yMeaning.rounded(toPlaces: 2)]
        
    }
    
    //move beacons interactively
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMaps", let viewController = segue.destination as? KnownMapsController {
            viewController.items = self.items    
        }
    }
    
 
    
    @objc func moveBeacon(recognizer: UIPanGestureRecognizer) {
     let translation = recognizer.translation(in: self.view)
     if let myView = recognizer.view {
     myView.center = CGPoint(x: myView.center.x + translation.x, y: myView.center.y + translation.y)
        positionLabel.text = "x=\(toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(myView.center.x), yPos: Double(myView.center.y))[0]),y=\(toMeters(verticalMeters: height, horizontalMeters: width, xPos: Double(myView.center.x), yPos: Double(myView.center.y))[1])"
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        mapImage.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }

    
    
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
