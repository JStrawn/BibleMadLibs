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
    
    var isClassic = false
    var finalPassage = String()
    let mysharedManager = DataAccessObject.sharedManager
    
    var userWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mysharedManager.playStoneGrindSound()
        
        
        var passage = mysharedManager.currentPassage?.blankPassage
        //var attributedPassage = NSMutableAttributedString(string: "")
        
        
//        
//        for word in userWords {
//            
//            print(passage!)
//            if let match = passage!.range(of: "\\<(.*?)\\>", options: .regularExpression) {
//                passage!.replaceSubrange(match, with: word)
//                
//                
//                //in a for loop get from the beginning to the <, minus 1, then append that to the attributed passage with the attributes, then go back and search for your end bracker
//                
//            }
//            
//            //GET THE POSITION OF THE FIRST angle bracket. then you know the LENGTH of the word. then you can apply nsattributed texrt to it.
//            
//            
//        }
        
        //get rid of the api's weird formatting
        var editedPassage = passage!.replacingOccurrences(of: " .", with: ".")
        editedPassage = editedPassage.replacingOccurrences(of: " ,", with: ",")
        editedPassage = editedPassage.replacingOccurrences(of: " :", with: ":")
        
        editedPassage += " \n\((mysharedManager.currentPassage?.bookName)!) \((mysharedManager.currentPassage?.chapter)!) \((mysharedManager.currentPassage?.lowerVerse)!):\((mysharedManager.currentPassage?.upperVerse)!)"
        finalPassage = editedPassage
        madLibTextLabel.text = editedPassage
        
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
