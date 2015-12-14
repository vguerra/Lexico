//
//  ViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 11/11/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import UIKit
import AVFoundation

class TranslateViewController: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var textToSpeek: UITextField!
    @IBOutlet weak var translateToLanguageButton: UIButton!
    @IBOutlet weak var translateToFlagLabel: UILabel!
    @IBOutlet weak var translateToLanguageLabel: UILabel!
    
    var translateToLanguage : Language?
    
    let speechSynthesizer = AVSpeechSynthesizer()

    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechSynthesizer.delegate = self
        
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


    @IBAction func speekTouchUpInside(sender: AnyObject) {
        let utterance = AVSpeechUtterance(string: textToSpeek.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        
        speechSynthesizer.speakUtterance(utterance)
    }
    
    @IBAction func translateToLanguageTouchUpInside(sender: AnyObject) {
        performSegueWithIdentifier("presentLanguagePicker", sender: nil)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        let attText = NSMutableAttributedString(string: utterance.speechString)
        attText.setAttributes([NSBackgroundColorAttributeName: UIColor.lightGrayColor()], range: characterRange)
        
        let spokenString = (utterance.speechString as NSString).substringWithRange(characterRange)
        print("about to speak: \(spokenString)")

        textToSpeek.attributedText = attText
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        print("did start")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        print("did finish")
    }
}

// Dictionary key: dict.1.1.20151116T223221Z.b505e3f3550e1503.a17459cd826bbf796883a82ae23f6a36cc46177b
// Translation key: trnsl.1.1.20151116T223538Z.ad543d124ed92780.1151a8f5c62bee4df561562739771bf7d93316c4