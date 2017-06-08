//
//  TextEntryScreen.swift
//  BibleMadLibs
//
//  Created by Maxwell Schneider on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import QuartzCore

class TextEntryScreen: UIViewController, UITextFieldDelegate {
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
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          view.addGestureRecognizer(tap)
          textInputField.delegate = self

     }
     
     override func viewWillAppear(_ animated: Bool) {
          
          if mysharedManager.currentPassage?.arrayOfBlanks.count == 0 {
               mysharedManager.currentPassage?.arrayOfBlanks.append("")
               let resultsVC = ResultsViewController()
               resultsVC.userWords = self.userWords
               self.present(resultsVC, animated: true, completion: nil)
               
          }
          
          setTextFieldBorder(textField: textInputField)
          textInputField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
          
          
          words = (mysharedManager.currentPassage?.arrayOfBlanks)!
          
          if words.count == 1 {
               wordsLeft.text = "Last Word!"
          } else {
               wordsLeft.text = "\(words.count - 1) left to go!"
          }
          
          wordTypeHint.isHidden = true
          
          var word = ""
          
          if words.count != 0 {
               word = words[0]
               wordTypeHint.text = "(\(word))"
          }
          
          if word.hasPrefix("a") {
               enterABlank.text = "ENTER AN"
          } else {
               enterABlank.text = "ENTER A"
          }
          
          
          textInputField.attributedPlaceholder = NSAttributedString(string: word,attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
          
          
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
          textField.adjustsFontForContentSizeCategory = true
          
          textField.layer.shadowColor = UIColor.white.cgColor
          textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
          textField.layer.shadowOpacity = 1.0
          textField.layer.shadowRadius = 0.0
     }
     
     @IBAction func mainMenuButtonWasPressed(_ sender: UIButton){
          dismiss(animated: true, completion: nil)
     }
     
     @IBAction func nextButtonWasPressed(_ sender: UIButton) {
          
          if textInputField.text == "" {
               let alertController = UIAlertController(title: "Empty Field", message:
                    "You have left an empty field. Please Fill it out.", preferredStyle: UIAlertControllerStyle.alert)
               alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
               
               self.present(alertController, animated: true, completion: nil)
               
          } else {
               if (mysharedManager.currentPassage?.arrayOfBlanks.count)! != 0 {
                    let userInputWord = textInputField.text
                    userWords.append(userInputWord!)
                    mysharedManager.currentPassage?.arrayOfBlanks.remove(at: 0)
                    viewWillAppear(true)
                    textInputField.text = ""

               }
          }
          
     }
     
     
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          nextButtonWasPressed(nextButton)
          return true
     }
     
     
     func dismissKeyboard() {
          view.endEditing(true)
     }
     
}
