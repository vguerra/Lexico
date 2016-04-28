//
//  speakTextView.swift
//  Lexico
//
//  Created by Victor Guerra on 17/03/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayingNow {
    case Original, Translated, None
}

class SpeakTextViewController: UIViewController, AVSpeechSynthesizerDelegate {
    static let speeds : [Float] = [0.50, 0.40, 0.20]

    @IBOutlet weak var playOriginal: UIButton!
    @IBOutlet weak var pauseOriginal: UIButton!
    @IBOutlet weak var playTranslated: UIButton!
    @IBOutlet weak var pauseTranslated: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var stopOriginal: UIButton!
    @IBOutlet weak var stopTranslated: UIButton!

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

    var playingStatus : PlayingNow = .None

    override func viewDidLoad() {
        super.viewDidLoad()
        speechSynthesizer.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }

    //MARK : IBActions

    @IBAction func stopOriginalTouchUp(sender: AnyObject) {
        guard playingStatus == .Original else {
            return
        }
        stopSpeech()
    }

    @IBAction func stopTranslatedTouchUp(sender: AnyObject) {
        guard playingStatus == .Translated else {
            return
        }
        stopSpeech()
    }

    @IBAction func closePopover(sender: AnyObject) {
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func playOriginalTouchUp(sender: AnyObject) {
        guard playingStatus == .None else {
            return
        }
        playingStatus = .Original
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
        guard playingStatus == .None else {
            return
        }
        playingStatus = .Translated
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
        playOriginal.hidden = false
        playTranslated.hidden = false
        pauseOriginal.hidden = true
        stopOriginal.hidden = false
        pauseTranslated.hidden = true
        stopTranslated.hidden = false

        if let origText = originalTextParam {
            originalText.attributedText = Helpers.generateAttributedText(origText)
        } else {
            playOriginal.hidden = true
            stopOriginal.hidden = true
            originalText.hidden = true
        }

        if let transText = translatedTextParam {
            translatedText.attributedText = Helpers.generateAttributedText(transText)
        } else {
            playTranslated.hidden = true
            stopTranslated.hidden = true
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
        speakingText?.attributedText = Helpers.generateAttributedText(utterance.speechString, highlightRange: characterRange)
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        stopSpeech()
    }

    func stopSpeech() {
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        configure()
        playingStatus = .None
    }
}
