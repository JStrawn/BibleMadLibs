//
//  DataAccessObject.swift
//  BibleMadLibs
//
//  Created by Andy Wu on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import Foundation


class DataAccessObject {
    static let sharedManager = DataAccessObject()
    
    func downloadPassage(book:String, chapter:Int, lowerVerse:Int, upperVerse:Int, completion:@escaping (_ text:String) -> Void) {
        
        let urlString = "http://labs.bible.org/api/?passage=\(book)%\(chapter):\(lowerVerse)-\(upperVerse)&type=json&formatting=plain"
        
        print(urlString)
        
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
                
                print(jsonData["madlib"] as! String)
                
                completion(jsonData["madlib"] as! String)
            }
            
        }.resume()
        
    }
    
    func getBlanks(oldPassage:String, blankPassage:String) {
        
    }
    
    
    func getNewPassage() {
        self.downloadPassage(book: "john", chapter: 203, lowerVerse: 16, upperVerse: 20, completion: { (passage) in
            //print(passage)
            print("\nMadlib-ifying passage\n")
            self.madlibifyPassage(passage: passage, completion: { (text) in
                print("\nGetting blanks\n")
                self.getBlanks(oldPassage: passage, blankPassage: text)
            })
        })
    }
    
    
    func checkForWordTypes(passage: String) {
        
        
        
    }
    
    
    
    
    
    
}
