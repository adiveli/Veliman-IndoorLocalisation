//
//  InfoController.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 10/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit
import CoreLocation

class InfoController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var startCalibrateButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var trigger = Int()
    
    var countdownTimer: Timer!
    var totalTime = 15
    
    var currentUUID = UUID()
    var major = String()
    var minor = String()
    var name = String()
    
    var contentWidth : CGFloat = 0.0
    
    let locationManager = CLLocationManager()
    
    
    var rssiArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.bringSubview(toFront: finishBtn)
        view.bringSubview(toFront: startCalibrateButton)
        startCalibrateButton.isEnabled = true
        finishBtn.isEnabled = false
        //resultLabel.isEnabled = false
        //timeLabel.isEnabled = false
        scrollViewSettings()
        
        print(trigger)
        
        if (trigger == 0){
            var values = scrollView.frame
            values.origin.x = 0
            values.origin.y = 0
            scrollView.scrollRectToVisible(values, animated: true)
            pageControl.currentPage = 0
            finishBtn.alpha = 0.0
        }else if(trigger == 1){
            var values = scrollView.frame
            values.origin.x = 375
            values.origin.y = 0
            scrollView.scrollRectToVisible(values, animated: true)
            pageControl.currentPage = 1
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.startCalibrateButton.alpha = 1.0
            })
        }
        
        print(currentUUID)
        print(major)
        print(minor)
        print(name)
        
        
    }
    @IBAction func startPressed(_ sender: Any) {
        timeLabel.isEnabled = true
        
        startTimer()
        startCalibrateButton.isEnabled = false
        let majorV = Int(major) ?? 0
        let minorV = Int(minor) ?? 0
        let newItem = Item(name: name, uuid: self.currentUUID, majorValue: majorV, minorValue: minorV)
        
        
        let beaconRegion = newItem.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
    }
    @IBAction func finishPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateTime() {
        timeLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            let majorV = Int(major) ?? 0
            let minorV = Int(minor) ?? 0
            let newItem = Item(name: name, uuid: self.currentUUID, majorValue: majorV, minorValue: minorV)
            
            
            let beaconRegion = newItem.asBeaconRegion()
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
            
            var suma = Int()
            for value in rssiArray{
                suma+=value
            }
            
            if (suma != 0){
                resultLabel.text = "Measured power value: \(suma/rssiArray.count)"}
            else{
                resultLabel.text = "No device around!"
            }
            
            resultLabel.textColor = UIColor.black
            //resultLabel.text = "Measured power value: "
            finishBtn.isEnabled = true
        }
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    
    func endTimer() {
        countdownTimer.invalidate()
    }

    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 1{
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.startCalibrateButton.alpha = 1.0
                self.finishBtn.alpha = 1.0
            })
            
        } else if Int(currentPage) == 0{
                self.startCalibrateButton.alpha = 0.0
                self.finishBtn.alpha = 0.0
        }
            // Show the "Let's Start" button in the last slide (with a fade in animation)                     UIView.animate(withDuration: 1.0, animations: { () -> Void in
        
    }
    
    func scrollViewSettings(){
        
        pageControl.pageIndicatorTintColor = UIColor.gray
        //1
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        //3
        let imgOne = UIImageView(frame: CGRect(x:58 + view.frame.width, y:153,width:258, height:179))
        imgOne.image = UIImage(named: "CalibrationDiagram.png")
        
        let text1 = UITextView(frame: CGRect(x: 8, y: 138, width: 359, height: 488))
        text1.text = "To provide the best user experience, it is critical to perform calibration in your deployment environment. As each beacon is installed you should perform a calibration step. \n\n • Install the beacon and have it emitting a signal. \n\n • Repeatedly sample the signal strength at a distance of 1 meter for a minimum of 10 seconds. When taking these signal strength readings you should hold the device in a portrait orientation with the top half of the device unobstructed.\n\n • Move the device slowly back and forth on a 30cm line, maintaining orientation, and remaining equidistant from the measuring device (see diagram)"
        text1.font = .systemFont(ofSize: 18)
        text1.textAlignment = .center
        text1.textColor = UIColor.black
        text1.isEditable = false
        
        
        self.scrollView.addSubview(text1)
        self.scrollView.addSubview(imgOne)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 2, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        self.startCalibrateButton.alpha = 0.0
        
        
        
    }
    
 
}


extension InfoController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for beacon in beacons{
            
            rssiArray.append(beacon.rssi)
            
            
        }
        
    }
    
    
}
