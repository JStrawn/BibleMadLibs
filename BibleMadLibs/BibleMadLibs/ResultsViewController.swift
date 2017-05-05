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
    @IBOutlet weak var stoneImageView: UIImageView!
    var isClassic = false
    var finalPassage = String()
    let mysharedManager = DataAccessObject.sharedManager
    
    var userWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var passage = mysharedManager.currentPassage?.blankPassage
        
        for word in userWords {
            if let match = passage!.range(of: "\\<(.*?)\\>", options: .regularExpression) {
                passage!.replaceSubrange(match, with: word)
            }
            
        }
        
        var editedPassage = passage!.replacingOccurrences(of: " .", with: ".")
        editedPassage = editedPassage.replacingOccurrences(of: " ,", with: ",")
        editedPassage = editedPassage.replacingOccurrences(of: " :", with: ":")
        
        //madLibTextLabel.isHidden = true
        editedPassage += " \n\((mysharedManager.currentPassage?.bookName)!) \((mysharedManager.currentPassage?.chapter)!) \((mysharedManager.currentPassage?.lowerVerse)!):\((mysharedManager.currentPassage?.upperVerse)!)"
        finalPassage = editedPassage
        madLibTextLabel.text = editedPassage
    }
    
    @IBAction func classicButtonPressed(_ sender: UIButton){

        
        if isClassic == true {
            madLibTextLabel.text = finalPassage
            isClassic = false
        }else{
            var ogPassage:String = (mysharedManager.currentPassage?.oldPassage)!
            ogPassage += " \n\((mysharedManager.currentPassage?.bookName)!) \((mysharedManager.currentPassage?.chapter)!) \((mysharedManager.currentPassage?.lowerVerse)!):\((mysharedManager.currentPassage?.upperVerse)!)"
        madLibTextLabel.text = ogPassage
            isClassic = true
        }
    }
    
    @IBAction func backToMenuButtonWasTapped(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func shareButton(_ sender: Any) {
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
