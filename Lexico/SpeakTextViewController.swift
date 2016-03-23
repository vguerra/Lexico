//
//  speakTextView.swift
//  Lexico
//
//  Created by Victor Guerra on 17/03/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import UIKit

class SpeakTextViewController: UIViewController {

    @IBOutlet weak var playOriginal: UIButton!
    @IBOutlet weak var pauseOriginal: UIButton!
    @IBOutlet weak var playTranslated: UIButton!
    @IBOutlet weak var pauseTranslated: UIButton!


    @IBOutlet weak var originalText: UITextView!

    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var closeButton: UIButton!


    //MARK : IBActions

    @IBAction func closePopover(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    // MARK : Helper functions
    func configure() {
        pauseOriginal.hidden = true
        playTranslated.hidden = true
        pauseTranslated.hidden = true
    }

}
