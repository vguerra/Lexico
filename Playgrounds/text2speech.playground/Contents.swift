//: Playground - noun: a place where people can play

import AVFoundation

let textToSpeak = "this is some text"

let utterance = AVSpeechUtterance(string: textToSpeak)
utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
utterance.volume

let speechSynthesizer = AVSpeechSynthesizer()

speechSynthesizer.speakUtterance(utterance)

