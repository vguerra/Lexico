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

    @IBOutlet weak var translateToLanguageButton: UIButton!
    @IBOutlet weak var translateToFlagLabel: UILabel!
    @IBOutlet weak var translateToLanguageLabel: UILabel!
    
    @IBOutlet weak var originalText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
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


//    @IBAction func speekTouchUpInside(sender: AnyObject) {
//        let utterance = AVSpeechUtterance(string: textToSpeek.text!)
//        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
//        
//        speechSynthesizer.speakUtterance(utterance)
//    }
    
    @IBAction func translateToLanguageTouchUpInside(sender: AnyObject) {
        performSegueWithIdentifier("presentLanguagePicker", sender: nil)
    }
    
    @IBAction func translateTouchUpInside(sender: AnyObject) {
        
        Glosbe.translate(languages[0], translateToLanguage!, originalText.text) { trnResult in
            switch trnResult {
            case .Failure(let error):
                print("An error ocurred: \(error)")
            case .Success(let translation):
                print("Success: \(translation)")
            }
        }
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
//        let attText = NSMutableAttributedString(string: utterance.speechString)
//        attText.setAttributes([NSBackgroundColorAttributeName: UIColor.lightGrayColor()], range: characterRange)
//        
//        let spokenString = (utterance.speechString as NSString).substringWithRange(characterRange)
//        print("about to speak: \(spokenString)")
//
//        textToSpeek.attributedText = attText
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        print("did start")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        print("did finish")
    }
}

