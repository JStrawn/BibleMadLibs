//
//  ResultsViewController.swift
//  BibleMadLibs
//
//  Created by Juliana Strawn on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var madLibTextLabel: UITextView!
    @IBOutlet weak var classicButton: UIButton!
    @IBOutlet weak var stone: UIImageView!
    
    var isClassic = false
    var finalPassage = String()
    let mysharedManager = DataAccessObject.sharedManager
    
    var userWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mysharedManager.playStoneGrindSound()
        
        
        var passage = mysharedManager.currentPassage?.blankPassage
        //var attributedPassage = NSMutableAttributedString(string: "")
        
        
        
        for word in userWords {
            
            print(passage!)
            if let match = passage!.range(of: "\\<(.*?)\\>", options: .regularExpression) {
                passage!.replaceSubrange(match, with: word)
                
                
                //in a for loop get from the beginning to the <, minus 1, then append that to the attributed passage with the attributes, then go back and search for your end bracker
                
            }
            
            //GET THE POSITION OF THE FIRST angle bracket. then you know the LENGTH of the word. then you can apply nsattributed texrt to it.
            
            
        }
        
        //get rid of the api's weird formatting
        var editedPassage = passage!.replacingOccurrences(of: " .", with: ".")
        editedPassage = editedPassage.replacingOccurrences(of: " ,", with: ",")
        editedPassage = editedPassage.replacingOccurrences(of: " :", with: ":")
        editedPassage = editedPassage.replacingOccurrences(of: " !", with: "!")
        
        editedPassage += " \n\((mysharedManager.currentPassage?.bookName)!) \((mysharedManager.currentPassage?.chapter)!) \((mysharedManager.currentPassage?.lowerVerse)!):\((mysharedManager.currentPassage?.upperVerse)!)"
        finalPassage = editedPassage
        madLibTextLabel.text = editedPassage
        
        mysharedManager.currentPassage?.editedPassage = editedPassage
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        madLibTextLabel.fadeOut()
        self.madLibTextLabel.scrollRangeToVisible(NSMakeRange(0, 0))
        
        //Stone tablet animation
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.madLibTextLabel.fadeIn()
        })
        
        
        let slideAnimation = CABasicAnimation(keyPath: "position.y")
        slideAnimation.fromValue = self.view.frame.maxY + stone.frame.height
        slideAnimation.toValue = self.view.frame.minY + stone.frame.height / 1.8
        
        
        let shakeAnimation = CABasicAnimation(keyPath: "position.x")
        shakeAnimation.repeatCount = 75
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.06
        shakeAnimation.fromValue = self.view.frame.width/1.8 - 5
        shakeAnimation.toValue =  self.view.frame.width/1.8 + 5
        
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1.5
        groupAnimation.animations = [slideAnimation, shakeAnimation]
        
        stone.layer.add(groupAnimation, forKey: nil)
        CATransaction.commit()

    }
    
    
    @IBAction func classicButtonPressed(_ sender: UIButton){
        
        if isClassic == true {
            madLibTextLabel.text = finalPassage
            classicButton.setTitle("Classic", for: .normal)
            isClassic = false
        }else{
            var ogPassage:String = (mysharedManager.currentPassage?.oldPassage)!
            ogPassage += " \n\((mysharedManager.currentPassage?.bookName)!) \((mysharedManager.currentPassage?.chapter)!) \((mysharedManager.currentPassage?.lowerVerse)!):\((mysharedManager.currentPassage?.upperVerse)!)"
            madLibTextLabel.text = ogPassage
            classicButton.setTitle("Mad Libs", for: .normal)
            isClassic = true
        }
    }
    
    
    @IBAction func backToMenuButtonWasTapped(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        
        mysharedManager.playThunderSound()
        
        // text to share
        let text = finalPassage
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}

