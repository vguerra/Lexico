//
//  speakTextView.swift
//  Lexico
//
//  Created by Victor Guerra on 17/03/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import UIKit
import AVFoundation

class SpeakTextViewController: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var playOriginal: UIButton!
    @IBOutlet weak var pauseOriginal: UIButton!
    @IBOutlet weak var playTranslated: UIButton!
    @IBOutlet weak var pauseTranslated: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var originalText: UITextView!
    @IBOutlet weak var translatedText: UITextView!

    var speakingText: UITextView?
    var originalTextParam : String?
    var translatedTextParam : String?
    var originalLanguage : Language?
    var translateToLanguage : Language?

    let speechSynthesizer = AVSpeechSynthesizer()
    var originalPlayed : Int = -1
    var translatedPlayed : Int = -1

    static let speeds : [Float] = [0.50, 0.40, 0.20]


    override func viewDidLoad() {
        super.viewDidLoad()
        speechSynthesizer.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }

    //MARK : IBActions
    @IBAction func closePopover(sender: AnyObject) {
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func playOriginalTouchUp(sender: AnyObject) {
        toggleOriginalButtons()
        if speechSynthesizer.paused {
            speechSynthesizer.continueSpeaking()
            return
        }
        originalPlayed += 1
        let speedIndex = originalPlayed % SpeakTextViewController.speeds.count
        speakText(originalText, language: originalLanguage!, speedFactor: SpeakTextViewController.speeds[speedIndex])
    }

    @IBAction func pauseOriginalTouchUp(sender: AnyObject) {
        speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        toggleOriginalButtons()
    }

    @IBAction func playTranslatedTouchUp(sender: AnyObject) {
        toggleTranslatedButtons()
        if speechSynthesizer.paused {
            speechSynthesizer.continueSpeaking()
            return
        }
        translatedPlayed += 1
        let speedIndex = translatedPlayed % SpeakTextViewController.speeds.count
        speakText(translatedText, language: translateToLanguage!, speedFactor: SpeakTextViewController.speeds[speedIndex])
    }

    @IBAction func pauseTranslatedTouchUp(sender: AnyObject) {
        speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        toggleTranslatedButtons()
    }

    // MARK : Helper functions

    func toggleOriginalButtons() {
        swap(&playOriginal.hidden, &pauseOriginal.hidden)
    }

    func toggleTranslatedButtons() {
        swap(&playTranslated.hidden, &pauseTranslated.hidden)
    }

    func configure() {
        if let origText = originalTextParam {
            pauseOriginal.hidden = true
            playOriginal.hidden = false
            originalText.attributedText = Helpers.generateAttributedText(origText)
        } else {
            pauseOriginal.hidden = true
            playOriginal.hidden = true
            originalText.hidden = true
        }

        if let transText = translatedTextParam {
            pauseTranslated.hidden = true
            playTranslated.hidden = false
            translatedText.attributedText = Helpers.generateAttributedText(transText)
        } else {
            pauseTranslated.hidden = true
            playTranslated.hidden = true
            translatedText.hidden = true
        }
    }

    // MARK: Speak text and conforming to AVSpeechSynthesizerDelegate
    func speakText(textView: UITextView, language : Language, speedFactor : Float = 1.0) {
        guard !textView.text.isEmpty else { return }
        if (!speechSynthesizer.speaking) {
            let utterance = AVSpeechUtterance(string: textView.text)
            utterance.rate = AVSpeechUtteranceMaximumSpeechRate * speedFactor
            utterance.voice = AVSpeechSynthesisVoice(language: language.tag)
            speechSynthesizer.speakUtterance(utterance)
            speakingText = textView
        }
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
//        let attText = NSMutableAttributedString(string: utterance.speechString)
//        attText.setAttributes([NSBackgroundColorAttributeName: UIColor.lightGrayColor()], range: characterRange)
        speakingText?.attributedText = Helpers.generateAttributedText(utterance.speechString, highlightRange: characterRange)
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        configure()
    }
}
