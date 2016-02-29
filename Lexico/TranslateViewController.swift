//
//  ViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 11/11/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import UIKit
import AVFoundation

class TranslateViewController: BaseViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var pickTargetLanguage: UIButton!
    @IBOutlet weak var speakOriginalText: UIButton!
    @IBOutlet weak var doTranslation: UIButton!
    @IBOutlet weak var originalText: UITextField!

    @IBOutlet weak var resultsTable: UITableView!

    var translateToLanguage : Language?
    var translation : Translation?

    let originalLanguage = LanguagesManager.sharedInstace.originalLanguage

    var hasText : Bool {
        return !originalText.text!.isEmpty
    }
    var hasTranslateToLanguage : Bool {
        return translateToLanguage != nil
    }

    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalText.delegate = self
        resultsTable.delegate = self
        resultsTable.dataSource = self
        
        //resultsTable.estimatedRowHeight = 100.0
        //resultsTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedLanguage = UserPreferences.getTranslateToLanguage() {
            translateToLanguage = savedLanguage
            pickTargetLanguage.setTitle(savedLanguage.nameAndFlag,
                forState: .Normal)
        }
        
        enableButton(doTranslation, enabled: hasText && hasTranslateToLanguage)
        enableButton(speakOriginalText, enabled: hasText && hasTranslateToLanguage)
    }
    
    @IBAction func pickTargetLanguageTouchUpInside(sender: AnyObject) {
        performSegueWithIdentifier("presentLanguagePicker", sender: nil)
    }
    
    @IBAction func translateTouchUpInside(sender: AnyObject) {
        startActivityAnimation(message: "Loading Translations...")
        Glosbe.translate(originalLanguage, translateToLanguage!, originalText.text!) { trnResult in
            switch trnResult {
            case .Failure(let error):
                self.stopActivityAnimation()
                self.showWarning(title: "Something went wrong!😕", message: error.description)
                print("An error ocurred: \(error)")
            case .Success(let resultTranslation):
                self.translation = resultTranslation
                self.performResultsDisplay()
                self.stopActivityAnimation()
            }
        }
    }
    
    @IBAction func speakFromLanguageTouchUpInside(sender: AnyObject) {
        speakText(originalText.text!, inLanguage: originalLanguage)
    }
    
    
    // MARK: Conforming to UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if (string.isEmpty && textField.text!.characters.count == 1) {
            enableButton(speakOriginalText, enabled: false)
            enableButton(doTranslation, enabled: false)
        } else {
            enableButton(speakOriginalText, enabled: true)
            enableButton(doTranslation, enabled: hasTranslateToLanguage)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: Conforming to UITableViewDataSource protocol
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translation?.examples.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let translationCell = tableView.dequeueReusableCellWithIdentifier("translationViewCell",
            forIndexPath: indexPath) as! TranslationTableViewCell
        let example = translation!.examples[indexPath.row]
        translationCell.configureCell(example.0, translatedText: example.1, liked: false)
        return translationCell
    }
    
    // MARK: Helper functions
    func performResultsDisplay() {
        resultsTable.reloadData()
    }
    
    func enableButton(button : UIButton, enabled: Bool) {
        button.enabled = enabled
    }
}

