//
//  TranslationTableViewCell.swift
//  Lexico
//
//  Created by Victor Guerra on 28/02/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import UIKit

class TranslationTableViewCell : UITableViewCell {

    @IBOutlet weak var speakText: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!

    @IBOutlet weak var originalText: UILabel!
    @IBOutlet weak var translatedText: UILabel!

    var translateToLanguage : Language?
    var likeCallback : ((row : Int , liked : Bool) -> Void)?
    var speakCallback : ((row : Int) -> Void)?

    var row : Int?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: IBActions
    @IBAction func speakExample(sender: AnyObject) {
        speakCallback?(row: row!)
    }

    @IBAction func likeButtonTouchUpInside(sender: AnyObject) {
        toggleLikedState()
    }

    @IBAction func unlikeButtonTouchUpInside(sender: AnyObject) {
        toggleLikedState()
    }

    // MARK: Helper functions
    func configureCell(phrases : [String], originalText : String, translatedText : String, liked : Bool, language : Language, row : Int) {
        if phrases.count < 1 {
            likeButton.hidden = liked
            unlikeButton.hidden = !liked
            arrowButton.hidden = false
            self.originalText.attributedText = Helpers.generateAttributedText(originalText)
            self.translatedText.hidden = false
            self.translatedText.attributedText = Helpers.generateAttributedText(translatedText)
        } else {
            print("we got a translations one.")
            self.originalText.attributedText = Helpers.generateAttributedText(phrases.joinWithSeparator(", "))
            self.translatedText.hidden = true
            likeButton.hidden = true
            unlikeButton.hidden = true
            arrowButton.hidden = true
        }

        self.row = row
        translateToLanguage = language
    }

    private func toggleLikedState() {
        swap(&likeButton.hidden, &unlikeButton.hidden)
        likeCallback?(row: row!, liked: likeButton.hidden)
    }
}