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
    @IBOutlet weak var wordTypeHint: UILabel!
    
    let mysharedManager = DataAccessObject.sharedManager
    
    var words = [String]()
    var userWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setTextFieldBorder(textField: textInputField)
        textInputField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        
        
        words = mysharedManager.typesOfWords
        wordsLeft.text = "\(words.count - 1) left to go!"

        wordTypeHint.isHidden = true
        
        let word = words[0]
        wordTypeHint.text = "(\(word))"

        
        if word.hasPrefix("a") {
            enterABlank.text = "ENTER AN"
        } else {
            enterABlank.text = "ENTER A"
        }
        
        textInputField.attributedPlaceholder = NSAttributedString(string: word,
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
    }
    
    func textFieldDidChange() {
        if textInputField.text == "" {
            wordTypeHint.isHidden = true
        } else {
            wordTypeHint.isHidden = false
        }
    }
    
    
    func setTextFieldBorder(textField: UITextField) {
        
        textField.borderStyle = .none
        textField.layer.backgroundColor = UIColor.clear.cgColor
        
        textField.layer.masksToBounds = false
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 7.0
        textField.contentScaleFactor = 7.0
        
        textField.layer.shadowColor = UIColor.white.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowRadius = 0.0
    }
    
    @IBAction func nextButtonWasPressed(_ sender: UIButton) {
    
        if mysharedManager.typesOfWords.count > 1 {
        let userInputWord = textInputField.text
        userWords.append(userInputWord!)
        mysharedManager.typesOfWords.remove(at: 0)
        viewWillAppear(true)
        textInputField.text = ""
        print(words)
        print(userWords)
        } else {
            let vc = ResultsViewController()
            vc.userWords = self.userWords
            present(vc, animated: true, completion: nil)
        }
    }
}
