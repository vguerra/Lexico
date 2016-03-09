//
//  ViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 11/11/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import UIKit
import CoreData

class TranslateViewController: BaseViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var pickTargetLanguage: UIButton!
    @IBOutlet weak var speakOriginalText: UIButton!
    @IBOutlet weak var doTranslation: UIButton!
    @IBOutlet weak var originalText: UITextField!

    @IBOutlet weak var resultsTable: UITableView!

    var translateToLanguage : Language?
    var translation : Translation?

    var likedExamples : [Int : Favorite] = [:]

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

        navigationItem.title = "Translate"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        translateToLanguage = savedTranslateToLanguage
        if let savedLanguage = translateToLanguage {
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
        // save translation
        
        startActivityAnimation(message: "Loading Translations...")
        Glosbe.translate(originalLanguage, translateToLanguage!, originalText.text!) { trnResult in
            switch trnResult {
            case .Failure(_):
                self.stopActivityAnimation()
                self.showWarning(title: "Something went wrong!😕", message: "please try again later!")
            case .Success(let resultTranslation):
                self.translation = resultTranslation
                self.saveTranslation()
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
        translationCell.configureCell(example.0, translatedText: example.1, liked: false, language: translateToLanguage!, row: indexPath.row)
        translationCell.likeCallback = self.handleLike
        return translationCell
    }

    func handleLike(row : Int, liked: Bool) {
        if liked {
            let example = translation!.examples[row]
            let favoriteExample = Favorite(originalPhrase: example.0, translatedPhrase: example.1, context: self.sharedContext)
            favoriteExample.originalLanguage = originalLanguage
            favoriteExample.translateToLanguage = translateToLanguage!
            likedExamples.updateValue(favoriteExample, forKey: row)
        } else {
            sharedContext.deleteObject(likedExamples[row]!)
            likedExamples.removeValueForKey(row)
        }
        saveContext()
    }

    // MARK: History functions
    func saveTranslation() {
        guard self.translation != nil else { return }
        let savedTranslation = TranslationHistory(date: NSDate(),
            word: originalText.text!, context: self.sharedContext)
        savedTranslation.originalLanguage = originalLanguage
        savedTranslation.translateToLanguage = translateToLanguage
        saveContext()
    }
    
    // MARK: Helper functions
    func performResultsDisplay() {
        likedExamples.removeAll()
        resultsTable.reloadData()
    }
    
    func enableButton(button : UIButton, enabled: Bool) {
        button.enabled = enabled
    }
}

