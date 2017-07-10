//
//  Passage.swift
//  BibleMadLibs
//
//  Created by Andy Wu on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import Foundation


class Passage {
    
    var oldPassage:String
    var editedPassage:String?
    var blankPassage:String
    var arrayOfBlanks = [String]()
    
    var bookName:String?
    var chapter:Int?
    var lowerVerse:Int?
    var upperVerse:Int?
    
    
    init(oldString:String, blankString:String, blanks:[String]) {
        self.oldPassage = oldString
        self.blankPassage = blankString
        self.arrayOfBlanks = blanks
    }
    
}
