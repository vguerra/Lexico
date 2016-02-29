//
//  TextToSpeech.swift
//  Lexico
//
//  Created by Victor Guerra on 05/01/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import AVFoundation

/// Text to Speech - Singleton

class TextToSpeech : NSObject, AVSpeechSynthesizerDelegate {

    let speechSynthesizer = AVSpeechSynthesizer()
    
    static let sharedInstance = TextToSpeech()

    //    @IBAction func speekTouchUpInside(sender: AnyObject) {
    //        let utterance = AVSpeechUtterance(string: textToSpeek.text!)
    //        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
    //
    //        speechSynthesizer.speakUtterance(utterance)
    //    }
    
    override init() {
        super.init()
        //speechSynthesizer.delegate = TextToSpeech.sharedInstance
    }
    
    func speakText(text: String, language : Language) {
        guard !text.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language.tag)
        speechSynthesizer.speakUtterance(utterance)
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

