//
//  HomeScreenViewController.swift
//  BibleMadLibs
//
//  Created by Maxwell Schneider on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit


class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var playButton : UIButton!
    var verseOfTheDayText : UITextView!
    var godlibsTitle : UITextView!
    
    let mysharedManager = DataAccessObject.sharedManager
    var didDownloadNewPassage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mysharedManager.playHeavenSound()
        mysharedManager.loadDataFromTxtFile()
        
        scrollView.isUserInteractionEnabled = true
        //scrollView.isExclusiveTouch = true
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = false
        
        let myLongImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 3))
        myLongImage.image = UIImage(named: "godlibs")
        myLongImage.contentMode = .scaleAspectFill
        myLongImage.isUserInteractionEnabled = true
        self.scrollView.addSubview(myLongImage)
        
        playButton = UIButton(frame: CGRect(x: view.frame.midX - self.view.frame.width/6, y: myLongImage.frame.maxY - view.frame.height * 0.10, width: self.view.frame.width/3, height: 40))
        playButton.setTitle("PLAY", for: .normal)
        playButton.backgroundColor = UIColor.blue
        playButton.layer.cornerRadius = 15
        playButton.isUserInteractionEnabled = true
        playButton.addTarget(self, action: #selector(playButtonWasTapped), for: .touchUpInside)
        myLongImage.addSubview(playButton)
        
        godlibsTitle = UITextView(frame: CGRect(x: view.frame.midX - self.view.frame.width/2, y: myLongImage.frame.maxY - view.frame.height * 0.95, width: self.view.frame.width, height: self.view.frame.height/4))
        godlibsTitle.text = "GOD-LIBS"
        godlibsTitle.backgroundColor = UIColor.clear
        godlibsTitle.textColor = UIColor.white
        godlibsTitle.font = UIFont(name: "GelioKleftiko", size: 80)
        godlibsTitle.textAlignment = .center
        scrollView.addSubview(godlibsTitle)
        godlibsTitle.fadeOut()
        
        verseOfTheDayText = UITextView(frame: CGRect(x: view.frame.minX + 30, y: myLongImage.frame.maxY - view.frame.height * 0.80, width: view.frame.width/1.5, height: view.frame.height/2))
        verseOfTheDayText.backgroundColor = UIColor.clear
        verseOfTheDayText.textColor = UIColor.white
        scrollView.addSubview(verseOfTheDayText)
        verseOfTheDayText.isHidden = true
        
        
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.scrollView.contentOffset.y = CGFloat(self.view.frame.height * 3 - self.view.frame.height)
            }, completion: { complete in
                self.godlibsTitle.fadeIn()
                self.verseOfTheDayText.isHidden = false
            })
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
        self.playButton.isEnabled = false
        let status = Reachability.status()
        if case status = Reachability.unreachable{
            displayAlert()
            self.playButton.isEnabled = true
        } else {
            self.mysharedManager.downloadDailyVerse(completion: { (dailyVerse) in
                DispatchQueue.main.async {
                    self.verseOfTheDayText.text = dailyVerse
                }
            })
            
            mysharedManager.getNewPassage(completion: {
                //print(self.mysharedManager.currentPassage?.oldPassage as Any)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.didDownloadNewPassage = true
                self.playButton.isEnabled = true
            })
        }
        
        
    }
    
    func playButtonWasTapped() {
        if !didDownloadNewPassage {
            let status = Reachability.status()
            if case status = Reachability.unreachable{
                displayAlert()
            } else {
                self.playButton.isEnabled = false
                
                self.mysharedManager.downloadDailyVerse(completion: { (dailyVerse) in
                    DispatchQueue.main.async {
                        self.verseOfTheDayText.text = dailyVerse
                    }
                })
                
                mysharedManager.getNewPassage(completion: {
                    //print(self.mysharedManager.currentPassage?.oldPassage as Any)
                    DispatchQueue.main.async {
                        self.playButton.isEnabled = true
                        self.activityIndicator.stopAnimating()
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
    
    
    func displayAlert() {
        let alertController = UIAlertController(title: "No Network Detected", message:
            "Please connect to Wi-Fi and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.6, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.01, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}

