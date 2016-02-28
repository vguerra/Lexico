//
//  ViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 11/11/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import UIKit
import AVFoundation

class TranslateViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var pickTargetLanguage: UIButton!
    @IBOutlet weak var speakOriginalText: UIButton!
    @IBOutlet weak var doTranslation: UIButton!
    
    @IBOutlet weak var originalText: UITextField!
    var translateToLanguage : Language?
    
    let originalLanguage = LanguagesManager.sharedInstace.originalLanguage

    var haveText : Bool {
        return !originalText.text!.isEmpty
    }
    var haveTranslateToLanguage : Bool {
        return translateToLanguage != nil
    }

    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedLanguage = UserPreferences.getTranslateToLanguage() {
            translateToLanguage = savedLanguage
            pickTargetLanguage.setTitle(savedLanguage.nameAndFlag,
                forState: .Normal)
        }
        
        
        enableButton(doTranslation, enabled: haveText && haveTranslateToLanguage)
        enableButton(speakOriginalText, enabled: haveText && haveTranslateToLanguage)
    }
    
    @IBAction func pickTargetLanguageTouchUpInside(sender: AnyObject) {
        performSegueWithIdentifier("presentLanguagePicker", sender: nil)
    }
    
    @IBAction func translateTouchUpInside(sender: AnyObject) {
        startActivityAnimation(message: "Loading Translations...")
        Glosbe.translate(originalLanguage, translateToLanguage!, originalText.text!) { trnResult in
            switch trnResult {
            case .Failure(let error):
                print("An error ocurred: \(error)")
            case .Success(let translation):
                print("Success: \(translation)")
            }
            self.stopActivityAnimation()
        }
    }
    
    @IBAction func speakFromLanguageTouchUpInside(sender: AnyObject) {
        speakText(originalText.text!, inLanguage: originalLanguage)
    }
    
    
    // MARK: Conforming to UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if (string.isEmpty && textField.text!.characters.count == 1) {
            enableButton(speakOriginalText, enabled: false)
            enableButton(doTranslation, enabled: false)
        } else {
            enableButton(speakOriginalText, enabled: true)
            enableButton(doTranslation, enabled: haveTranslateToLanguage)
        }

        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: Helper functions
    
    func enableButton(button : UIButton, enabled: Bool) {
        button.enabled = enabled
    }
    
}

