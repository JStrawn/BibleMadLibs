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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var cloudsImageView: UIImageView!
    
    var verseOfTheDayText : UITextView!
    var godlibsTitle : UITextView!
    
    let mysharedManager = DataAccessObject.sharedManager
    var didDownloadNewPassage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mysharedManager.playHeavenSound()
        mysharedManager.loadDataFromTxtFile()
        
        scrollView.isUserInteractionEnabled = true
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = false
        
        playButton.addTarget(self, action: #selector(playButtonWasTapped), for: .touchUpInside)
        
        
        //        let labelSize = CGSize(width: view.frame.width, height: view.frame.height/6.0)
        //        let labelFrame = CGRect(x:view.frame.midX - (labelSize.width/2) , y: self.view.frame.midY - (labelSize.height/2), width: labelSize.width, height: labelSize.height)
        godlibsTitle = UITextView(frame: CGRect(x:cloudsImageView.frame.midX - (cloudsImageView.frame.width/2), y:contentView.bounds.midY/1.1, width: cloudsImageView.frame.width, height: self.view.frame.height/10))
        //        godlibsTitle = UITextView(frame: labelFrame)
        
        
        
        godlibsTitle.text = "GOD-LIBS"
        godlibsTitle.backgroundColor = UIColor.clear
        godlibsTitle.textContainerInset = UIEdgeInsetsMake(0,0,0,0)
        godlibsTitle.textColor = UIColor.white
        godlibsTitle.font = UIFont(name: "GelioKleftiko", size: 80)
        godlibsTitle.textAlignment = .center
        godlibsTitle.isUserInteractionEnabled = false
        cloudsImageView.addSubview(godlibsTitle)
        godlibsTitle.fadeOut()
        
        verseOfTheDayText = UITextView(frame: CGRect(x:cloudsImageView.frame.midX - (cloudsImageView.frame.width * 0.40), y:contentView.bounds.midY, width: cloudsImageView.frame.width * 0.80, height: self.view.frame.height/4))
        verseOfTheDayText.backgroundColor = UIColor.black
        verseOfTheDayText.textColor = UIColor.white
        verseOfTheDayText.isUserInteractionEnabled = false
        verseOfTheDayText.layer.cornerRadius = 15
        verseOfTheDayText.font = UIFont.systemFont(ofSize: 18)
        cloudsImageView.addSubview(verseOfTheDayText)
        verseOfTheDayText.fadeOut()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.8, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.scrollView.contentOffset.y = CGFloat(self.view.frame.height * 3 - self.view.frame.height)
            }, completion: { complete in
                self.godlibsTitle.fadeIn()
                self.verseOfTheDayText.fadeIn()
                self.verseOfTheDayText.alpha = 0.50
            })
            
        }
        
        self.playButton.layer.cornerRadius = 15
        self.playButton.isEnabled = false
        let status = Reachability.status()
        if case status = Reachability.unreachable{
            displayAlert()
            self.playButton.isEnabled = true
        } else {
            self.mysharedManager.downloadDailyVerse(completion: { (dailyVerse) in
                DispatchQueue.main.async {
                    self.verseOfTheDayText.text = "Randomly Generated Bible Verse: \n \n\(dailyVerse)"
                }
            })
            
            mysharedManager.getNewPassage(completion: {
                //print(self.mysharedManager.currentPassage?.oldPassage as Any)
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

