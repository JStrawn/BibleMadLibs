//
//  ResultsViewController.swift
//  BibleMadLibs
//
//  Created by Juliana Strawn on 5/4/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    let mysharedManager = DataAccessObject.sharedManager
    
    var userWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let passage = mysharedManager.passage
        print(passage!)
        
        
//        if let match = passage!.range(of: "(?<=<)[^>]+", options: .regularExpression) {
//            print(passage!.substring(with: match))
//            passage!.replacingOccurrences(of: match, with: <#T##String#>)
//        }
        

    }


}
