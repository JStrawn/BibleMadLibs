//
//  TextEntryScreen.swift
//  BibleMadLibs
//
//  Created by Maxwell Schneider on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import QuartzCore

class TextEntryScreen: UIViewController {
    @IBOutlet weak var wordsLeft: UILabel!
    @IBOutlet weak var enterABlank: UILabel!
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        setTextFieldBorder(textField: textInputField)

    }

    
    func setTextFieldBorder(textField: UITextField) {
        
        textField.borderStyle = .none
        textField.layer.backgroundColor = UIColor.white.cgColor
        
        textField.layer.masksToBounds = false
        //textField.layer.shadowColor = UIColor(r: 220, g: 220, b: 220).cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowRadius = 0.0
    }

}
