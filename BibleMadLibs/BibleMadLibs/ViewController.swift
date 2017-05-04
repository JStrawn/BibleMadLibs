//
//  ViewController.swift
//  BibleMadLibs
//
//  Created by Juliana Strawn on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImage: UIImageView!

    
    //var mask : CALayer?
    
    let mysharedManager = DataAccessObject.sharedManager


    override func viewDidLoad() {
        super.viewDidLoad()
        animate()
        
        mysharedManager.getNewPassage()
        
    }

    
    
    func animate() {
        
        self.loadingImage.image = UIImage(named: "White Bird")
        
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingImage.transform = CGAffineTransform(scaleX: 6.5, y: 6.5)
            self.loadingImage.alpha = 0.0
            self.loadingView.alpha = 0.0
        }) { (finished) in
            UIView.animate(withDuration: 0.1, animations: {
                self.loadingImage.isHidden = true
                self.loadingImage.transform = CGAffineTransform.identity
                self.loadingView.isHidden = true

            })
            let vc = HomeScreenViewController()
            self.present(vc, animated: false, completion: nil)
        }
    }

}

