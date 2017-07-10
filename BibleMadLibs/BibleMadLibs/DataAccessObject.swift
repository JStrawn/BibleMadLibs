//
//  DataAccessObject.swift
//  BibleMadLibs
//
//  Created by Andy Wu on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreData

var audioPlayer1 = AVAudioPlayer()
var audioPlayer2 = AVAudioPlayer()
var audioPlayer3 = AVAudioPlayer()


class DataAccessObject {
    static let sharedManager = DataAccessObject()
    
    var context: NSManagedObjectContext
    
    var currentPassage:Passage?
    
    var booksArray = [[String]]()
    
    var passageArray = [SavedPassage]()
    
    func downloadPassage(book:String, chapter:Int, lowerVerse:Int, upperVerse:Int, completion:@escaping (_ text:String) -> Void) {
        
        let urlString = "http://labs.bible.org/api/?passage=\(book)+\(chapter):\(lowerVerse)-\(upperVerse)&type=json&formatting=plain"
        
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
                // remove weird encoding for hebrew letters
                passage = passage.replacingOccurrences(of: "&#8211;", with: "-")
                passage = passage.replacingOccurrences(of: "&#1495;", with: "חֵ")
                passage = passage.replacingOccurrences(of: "&#1494;", with: "ז")
                completion(passage)
            }
            
        }.resume()
    }
    
    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "GodLibsDataModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        DispatchQueue.global(qos: .userInitiated).async  {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
             This code uses a file named "DataModel.sqlite" in the application's documents directory.
             */
            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
        
    }
    
    

    
    func downloadDailyVerse(completion:@escaping (_ text:String) -> Void) {
        let randInt = generateRandomNum(value: booksArray.count-1)
        
        let bookName:String = booksArray[randInt][0]
        
        var chapterNum:Int = generateRandomNum(value: Int(booksArray[randInt][1])!)
        
        if chapterNum == 0 {
            chapterNum = 1
        }
        
        var verseNum = generateRandomNum(value: Int(booksArray[randInt][2])!)
        
        if verseNum == 0 {
            verseNum = 1
        }
        
        let lowerVerseNum:Int = verseNum
        
        let upperVerseNum:Int = verseNum
        
        self.downloadPassage(book: bookName, chapter: chapterNum, lowerVerse: lowerVerseNum, upperVerse: upperVerseNum, completion: { (passage) in
            var newPassage = passage
            newPassage += "\n\((bookName)) \((chapterNum)) \((lowerVerseNum)):\((upperVerseNum))"
            completion(newPassage)
            
        })
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
        
        print("blanks count: \(typesOfWords)\n")
        
        if typesOfWords.count < 10 {
            self.getNewPassage(completion: {
                print("Getting New passage\n")
            })
        } else {
            //print(typesOfWords)
            print("10 blanks found\n")
            let newPassage = Passage(oldString: oldPassage, blankString: blankPassage, blanks: typesOfWords)
            
            completion(newPassage)
        }
        
        
    }
    
    
    func getNewPassage(completion:@escaping () -> Void) {
   
        let randInt = generateRandomNum(value: booksArray.count-1)
        //print(randInt)
        
        let bookName:String = booksArray[randInt][0]
        //print(bookName)
        
        var chapterNum:Int = generateRandomNum(value: Int(booksArray[randInt][1])!)
        
        if chapterNum == 0 {
            chapterNum = 1
        }
        
        //print("Chatper: \(chapterNum)")
        
        var verseNum = generateRandomNum(value: Int(booksArray[randInt][2])!)
        
        var subtractBy = 5
        
        if verseNum < 5 {
            verseNum = 5
            subtractBy = 4
        }
        
        let lowerVerseNum:Int = verseNum - subtractBy
        //print("Lower Verse: \(lowerVerseNum)")
        
        let upperVerseNum:Int = verseNum
        //print("Upper Verse: \(verseNum)")
        
        self.downloadPassage(book: bookName, chapter: chapterNum, lowerVerse: lowerVerseNum, upperVerse: upperVerseNum, completion: { (passage) in
            
            //print(passage)
            
            //print("\nMadlib-ifying passage\n")
            self.madlibifyPassage(passage: passage, completion: { (text) in
                //print("\nGetting blanks\n")
                self.getBlanks(oldPassage: passage, blankPassage: text, completion: { (newPassage) in
                    
                    //print("Finished getting new passage")
                    
                    newPassage.bookName = bookName
                    newPassage.chapter = chapterNum
                    newPassage.lowerVerse = lowerVerseNum
                    newPassage.upperVerse = upperVerseNum
                    
                    self.currentPassage = newPassage
                    
                    completion()
                
                })
            })
        })
        
    }
    
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
            
        } catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            
            return []
        }
    }
    
    
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
    

    func savePassage(){
        
        
 
        let passageToSave = NSEntityDescription.insertNewObject(forEntityName: "SavedPassage", into: context) as! SavedPassage
        passageToSave.editedPassage = currentPassage?.editedPassage
        passageToSave.oldPassage = currentPassage?.oldPassage
        
        saveData()
        
    }
    
        func saveData() {
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    
    
        func loadData() {
            let moc = context
            let loadPassage = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedPassage")
    
            do {
                let fetchPassage = try moc.fetch(loadPassage) as! [SavedPassage]
                passageArray = fetchPassage
            } catch {
                fatalError("Failed to fetch \(error)")
            }
        }
    
    func loadDataFromTxtFile() {
        let filename = "DataFile"
        
        if let path = Bundle.main.path(forResource: filename, ofType: nil) {
            do {
                let text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                
                let books = text.components(separatedBy: "\n")
                
                for bookData in books {
                    let data = bookData.components(separatedBy: ",")
                    self.booksArray.append(data)
                }
                
                //print(self.booksArray)
                self.booksArray.removeLast()
                
            } catch {
                print("Failed to read text")
            }
        } else {
            print("Failed to load file from app bundle")
        }
    }
    
    func generateRandomNum(value:Int) -> Int {
        let num = value + 1
        let randomNum = Int(arc4random_uniform(UInt32(num)))
        
        return randomNum
    }
    
    
}


