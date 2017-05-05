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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mysharedManager.playHeavenSound()
        //mysharedManager.playStoneGrindSound()
        //mysharedManager.playThunderSound()

        mysharedManager.loadDataFromTxtFile()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        mysharedManager.getNewPassage(completion: {
            print(self.mysharedManager.currentPassage?.oldPassage as Any)
            
        })
        
        
    }

    @IBAction func playButtonWasTapped(_ sender: UIButton) {
        
        let vc = TextEntryScreen()
        present(vc, animated: true, completion: nil)
        
    }

    @IBAction func tutorialButtonWasTapped(_ sender: UIButton){
        let tutVC = TutorialScreenViewController()
        present(tutVC, animated: true, completion: nil)
        
    }

}
