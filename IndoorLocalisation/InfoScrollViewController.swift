//
//  InfoScrollViewController.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 10/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import UIKit

class InfoScrollViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    let image2 = UIImageView(frame: CGRect(x: 157.7, y: 630, width: 10, height: 10))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        addProgressIntro()
        image2.image = UIImage.init(named: "SelectionCircleInfo")
        self.view.addSubview(image2)
        
        
        // Do any additional setup after loading the view.
    }
    
    func addProgressIntro(){
        
        let image1 = UIImageView(frame: CGRect(x: 157, y: 630, width: 70, height: 10))
        image1.image = UIImage.init(named: "progressBar")
        self.view.addSubview(image1)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}
