//
//  HomeScreenViewController.swift
//  BibleMadLibs
//
//  Created by Maxwell Schneider on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit


class HomeScreenViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
//    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var verseOfTheDayText: UILabel!
    
    let mysharedManager = DataAccessObject.sharedManager
    var didDownloadNewPassage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mysharedManager.playHeavenSound()
        //mysharedManager.playStoneGrindSound()
        //mysharedManager.playThunderSound()

        mysharedManager.loadDataFromTxtFile()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let status = Reachability.status()
        if case status = Reachability.unreachable{
            displayAlert()
        } else {
            self.mysharedManager.downloadDailyVerse(completion: { (dailyVerse) in
                DispatchQueue.main.async {
                    self.verseOfTheDayText.text = dailyVerse
                }
            })
            self.playButton.isEnabled = false
            mysharedManager.getNewPassage(completion: {
                //print(self.mysharedManager.currentPassage?.oldPassage as Any)
                self.didDownloadNewPassage = true
                self.playButton.isEnabled = true
            })
        }
        
        
    }

    @IBAction func playButtonWasTapped(_ sender: UIButton) {
        if !didDownloadNewPassage {
            let status = Reachability.status()
            if case status = Reachability.unreachable{
                displayAlert()
            } else {
                self.mysharedManager.downloadDailyVerse(completion: { (dailyVerse) in
                    DispatchQueue.main.async {
                        self.verseOfTheDayText.text = dailyVerse
                    }
                })
                self.playButton.isEnabled = false
                mysharedManager.getNewPassage(completion: {
                    //print(self.mysharedManager.currentPassage?.oldPassage as Any)
                    DispatchQueue.main.async {
                        self.playButton.isEnabled = true
                        let vc = TextEntryScreen()
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    
                })
            }
        }
        
        
        if didDownloadNewPassage {
            let vc = TextEntryScreen()
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }

    @IBAction func tutorialButtonWasTapped(_ sender: UIButton){
        let tutVC = TutorialScreenViewController()
        self.present(tutVC, animated: true, completion: nil)
        
    }
    
    func displayAlert() {
        let alertController = UIAlertController(title: "No Network Detected", message:
            "Please connect to Wi-Fi and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

}
