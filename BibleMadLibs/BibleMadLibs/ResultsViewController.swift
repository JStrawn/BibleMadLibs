import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var madLibTextLabel: UITextView!
    @IBOutlet weak var classicButton: UIButton!
    @IBOutlet weak var stone: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var isClassic = false
    var finalPassage = String()
    let mysharedManager = DataAccessObject.sharedManager
    var isLoaded = false
    var userWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.alpha = 0
        menuButton.layer.cornerRadius = 20
        if !isLoaded {
            
       
        mysharedManager.playStoneGrindSound()
        
        
        var passage = mysharedManager.currentPassage?.blankPassage
        //var attributedPassage = NSMutableAttributedString(string: "")
        
        
        
        for word in userWords {
            
//            print(passage!)
            if let match = passage!.range(of: "\\<(.*?)\\>", options: .regularExpression) {
                passage!.replaceSubrange(match, with: word)
                
                
                //in a for loop get from the beginning to the <, minus 1, then append that to the attributed passage with the attributes, then go back and search for your end bracker
                
            }
            
            //GET THE POSITION OF THE FIRST angle bracket. then you know the LENGTH of the word. then you can apply nsattributed texrt to it.
            
            
        }
        
        //get rid of the api's weird formatting
        var editedPassage = passage!.replacingOccurrences(of: " .", with: ".")
        editedPassage = editedPassage.replacingOccurrences(of: " ,", with: ",")
        editedPassage = editedPassage.replacingOccurrences(of: " :", with: ":")
        editedPassage = editedPassage.replacingOccurrences(of: " !", with: "!")
        
        editedPassage += " \n\((mysharedManager.currentPassage?.bookName)!) \((mysharedManager.currentPassage?.chapter)!): \((mysharedManager.currentPassage?.lowerVerse)!)-\((mysharedManager.currentPassage?.upperVerse)!)"
        finalPassage = editedPassage
        madLibTextLabel.text = editedPassage
        
        mysharedManager.currentPassage?.editedPassage = editedPassage
        }
        else{
            saveButton.isEnabled = false
            saveButton.backgroundColor = .black
            saveButton.alpha = 0
            madLibTextLabel.text = finalPassage
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        madLibTextLabel.fadeOut()
        self.madLibTextLabel.scrollRangeToVisible(NSMakeRange(0, 0))
        
        //Stone tablet animation
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.madLibTextLabel.fadeIn()
            self.menuButton.fadeIn()
        })
        
        
        
    }
    
    
    @IBAction func classicButtonPressed(_ sender: UIButton){
        
        var ogPassage:String
        
        if isClassic == true {
            madLibTextLabel.text = finalPassage
            classicButton.setTitle("Classic", for: .normal)
            isClassic = false
        }else{
            if !isLoaded{
            ogPassage = (mysharedManager.currentPassage?.oldPassage)!
            ogPassage += " \n\((mysharedManager.currentPassage?.bookName)!) \((mysharedManager.currentPassage?.chapter)!): \((mysharedManager.currentPassage?.lowerVerse)!)-\((mysharedManager.currentPassage?.upperVerse)!)"
            }
            else{
            ogPassage = (mysharedManager.currentPassage?.oldPassage)!
            }
            madLibTextLabel.text = ogPassage
            classicButton.setTitle("Mad Libs", for: .normal)
            isClassic = true
        }
    }
    
    
    @IBAction func backToMenuButtonWasTapped(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            

            let name = alertController.textFields?[0].text ?? "No name"
            self.mysharedManager.savePassage(name: name)
            
//            print("firstName \(firstTextField.text ?? "memes")")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a Save Name to remember this passage"
        }
    
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        self.madLibTextLabel.setContentOffset(.zero, animated: false)
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        
        mysharedManager.playThunderSound()
        
        // text to share
        let text = finalPassage
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}

