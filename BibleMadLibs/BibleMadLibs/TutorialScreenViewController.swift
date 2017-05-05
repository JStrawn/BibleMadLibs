//
//  TutorialScreenViewController.swift
//  BibleMadLibs
//
//  Created by Maxwell Schneider on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class TutorialScreenViewController: UIViewController {
    @IBOutlet weak var welcomeText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeText.numberOfLines = 0
        self.welcomeText.text = "Welcome, Disciple! \n This is God-Libs, a game where you play God with words! \n Please insert animations here to finish the scene."
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okayButtonWasPressed (_ sender: UIButton){
        
        let vc = HomeScreenViewController()
        present(vc, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
