//
//  ViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 11/11/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import UIKit
import AVFoundation

let originalLanguage = languages[0]

class TranslateViewController: UIViewController {

    @IBOutlet weak var translateToLanguageButton: UIButton!
    @IBOutlet weak var translateToFlagLabel: UILabel!
    @IBOutlet weak var translateToLanguageLabel: UILabel!
    
    @IBOutlet weak var originalText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    var translateToLanguage : Language?
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedLanguage = UserPreferences.getTranslateToLanguage() {
            translateToLanguage = savedLanguage
            translateToLanguageButton.setTitle(savedLanguage.name, forState: .Normal)
            translateToFlagLabel.text = savedLanguage.name
            translateToFlagLabel.text = savedLanguage.emoji
        }
    }
    
    @IBAction func translateToLanguageTouchUpInside(sender: AnyObject) {
        performSegueWithIdentifier("presentLanguagePicker", sender: nil)
    }
    
    @IBAction func translateTouchUpInside(sender: AnyObject) {
        
        Glosbe.translate(originalLanguage, translateToLanguage!, originalText.text) { trnResult in
            switch trnResult {
            case .Failure(let error):
                print("An error ocurred: \(error)")
            case .Success(let translation):
                print("Success: \(translation)")
            }
        }
    }
    
    @IBAction func speakFromLanguageTouchUpInside(sender: AnyObject) {
        speakText(originalText.text, inLanguage: originalLanguage)
    }
    
    @IBAction func speakToLanguageTouchUpInside(sender: AnyObject) {
        speakText(translatedText.text, inLanguage: translateToLanguage!)
    }
    
    // MARK: Helper functions
    func speakText(text: String, inLanguage: Language) {
        guard !text.isEmpty else { return }
        TextToSpeech.sharedInstance.speakText(text, language: inLanguage)
    }
    
}

