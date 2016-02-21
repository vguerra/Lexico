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

class TranslateViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var translateToLanguageButton: UIButton!
    @IBOutlet weak var speakOriginalText: UIButton!
    
    @IBOutlet weak var originalText: UITextField!
    var translateToLanguage : Language?
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedLanguage = UserPreferences.getTranslateToLanguage() {
            translateToLanguage = savedLanguage
            translateToLanguageButton.setTitle(savedLanguage.nameAndFlag,
                forState: .Normal)
        }
        
        if (originalText.text!.isEmpty) {
            enableSpeakOriginalTextButton(false)
        }
    }
    
    @IBAction func translateToLanguageTouchUpInside(sender: AnyObject) {
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
            enableSpeakOriginalTextButton(false)
        } else {
            enableSpeakOriginalTextButton(true)
        }

        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: Helper functions
    
    func enableSpeakOriginalTextButton(enabled : Bool) {
        speakOriginalText.enabled = enabled
    }
    
}
