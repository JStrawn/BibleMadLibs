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
        
        animateStone()
        
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
        finalPassage = editedPassage
        madLibTextLabel.text = editedPassage
    }
    
    @IBAction func classicButtonPressed(_ sender: UIButton){
        let ogPassage = mysharedManager.currentPassage?.blankPassage
        
        if isClassic == true {
            madLibTextLabel.text = finalPassage
            isClassic = false
        }else{
        
        madLibTextLabel.text = ogPassage
            isClassic = true
        }
    }
    
    @IBAction func backToMenuButtonWasTapped(_ sender: UIButton){
        //self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func animateStone() {
        
//        UIView.animate(withDuration: 2.3, animations: {
//            
//            self.stoneImageView.transform = CGAffineTransform(translationX: 0, y: -600)
//            
//        }) { (finished) in
//            UIView.animate(withDuration: 0.1, animations: {
//                
//                self.madLibTextLabel.isHidden = false
//                
//            })
//        }
        
        //moveImageView(imgView: stoneImageView)
        
        
        
    }
    
//    func moveImageView(imgView: UIImageView){
//        let toPoint:CGPoint = CGPoint(x: 0.0, y: -100.0)
//        let fromPoint:CGPoint = CGPoint.zero
//        let movement = CABasicAnimation(keyPath: "movement")
//        movement.isAdditive = true
//        movement.fromValue = NSValue(cgPoint: fromPoint)
//        movement.toValue = NSValue(cgPoint: toPoint)
//        movement.duration = 1.3
//        imgView.layer.add(movement, forKey: "move")
//    }
}
