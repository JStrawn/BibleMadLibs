//
//  DataAccessObject.swift
//  BibleMadLibs
//
//  Created by Andy Wu on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer1 = AVAudioPlayer()
var audioPlayer2 = AVAudioPlayer()
var audioPlayer3 = AVAudioPlayer()


class DataAccessObject {
    static let sharedManager = DataAccessObject()
    
    var currentPassage:Passage?
    
    func downloadPassage(book:String, chapter:Int, lowerVerse:Int, upperVerse:Int, completion:@escaping (_ text:String) -> Void) {
        
        let urlString = "http://labs.bible.org/api/?passage=\(book)%\(chapter):\(lowerVerse)-\(upperVerse)&type=json&formatting=plain"
        
        //print(urlString)
        
        guard let url = URL(string: urlString)
            else {return}
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            guard let myData:Data = data
                else {return}
            
            var passage = ""
            
            if let jsonDataArray = try? JSONSerialization.jsonObject(with: myData, options: []) as? [[String: Any]] {
                for eachData in jsonDataArray! {
                    let text = eachData["text"]
                    passage += text as! String
                    passage += " "
                }
                
                completion(passage)
            }
            
        }.resume()
    }
    
    
    
    func madlibifyPassage(passage:String, completion:@escaping (_ text:String) -> Void) {
        
        let urlComponents = NSURLComponents(string: "http://libberfy.herokuapp.com?")!
        
        urlComponents.queryItems = [
            NSURLQueryItem(name: "q", value: passage) as URLQueryItem
        ]
        
        guard let url = urlComponents.url
            else {return}
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            guard let myData:Data = data
                else {return}
            
            if let jsonData = try? JSONSerialization.jsonObject(with: myData, options: []) as! [String:Any] {
                
                var blankPassage = ""
                blankPassage = jsonData["madlib"] as! String
                //print(blankPassage)
                
                completion(blankPassage)
            }
            
        }.resume()
        
    }
    
    func getBlanks(oldPassage:String, blankPassage:String, completion:@escaping (_ newText:Passage) -> Void) {
        //extract the nouns, verbs, and other word types
        var typesOfWords = [String]()
        
        let matches = self.matchesForRegexInText(regex: "\\<(.*?)\\>", text: blankPassage)
        print(matches)
        
        for match in matches {
            let editedMatch = match.replacingOccurrences(of: "<", with: "")
            let secondEditedMatch = editedMatch.replacingOccurrences(of: ">", with: "")
            let finalEditedMatch = secondEditedMatch.replacingOccurrences(of: "_", with: " ")
            
            typesOfWords.append(finalEditedMatch)
        }
        
        print(typesOfWords)
        
        let newPassage = Passage(oldString: oldPassage, blankString: blankPassage, blanks: typesOfWords)
        
        
        
        completion(newPassage)
    }
    
    
    func getNewPassage(completion:@escaping () -> Void) {
        
        self.downloadPassage(book: "john", chapter: 203, lowerVerse: 16, upperVerse: 20, completion: { (passage) in
            
            print("\nMadlib-ifying passage\n")
            self.madlibifyPassage(passage: passage, completion: { (text) in
                print("\nGetting blanks\n")
                self.getBlanks(oldPassage: passage, blankPassage: text, completion: { (newPassage) in
                    
                    print("Finished getting new passage")
                    self.currentPassage = newPassage
                
                })
            })
        })
        
    }
    
    
    func checkForWordTypes(passage: String) {


    }
    
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            
            let results = regex.matches(in: text,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
            
        } catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            
            return []
        }}
    
    
    func playHeavenSound(){
        do {
            audioPlayer1 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource:"HeavenSound", ofType:"mp4")!))
            audioPlayer1.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
        audioPlayer1.play()
    }
    
    func playStoneGrindSound(){
        do {
            audioPlayer2 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource:"StoneGrind", ofType:"mp4")!))
            audioPlayer2.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
        audioPlayer2.play()
    }
    
    func playThunderSound(){
        do {
            audioPlayer3 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource:"ThunderSound", ofType:"mp4")!))
            audioPlayer3.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
        audioPlayer3.play()
    }
    

    
    
    
}
