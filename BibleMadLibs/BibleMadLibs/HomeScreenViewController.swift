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
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var verseOfTheDayText: UILabel!
    
    let mysharedManager = DataAccessObject.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mysharedManager.playHeavenSound()
        //mysharedManager.playStoneGrindSound()
        //mysharedManager.playThunderSound()


    }


    

}
