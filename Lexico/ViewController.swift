//
//  ViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 11/11/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var textToSpeek: UITextField!
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechSynthesizer.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func speekTouchUpInside(sender: AnyObject) {
        let utterance = AVSpeechUtterance(string: textToSpeek.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-EN")
        
        speechSynthesizer.speakUtterance(utterance)
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

