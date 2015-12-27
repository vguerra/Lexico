//
//  LanguagePickerController.swift
//  Lexico
//
//  Created by Victor Guerra on 09/12/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import UIKit

// TODO: This has to be moved somewhere else

let languages = [
    Language(code: "eng", tag: "en_US", name: "English", emoji: "🇬🇧"),
    Language(code: "spa", tag: "es_ES", name: "Spanish", emoji: "🇪🇸")
]

enum SBIdentifiers : String {
    case languageTableViewCell = "languageCell"
}

class LanguagePickerController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var languagesTableView: UITableView!
    var translateToLanguage : Language?
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagesTableView.dataSource = self
        languagesTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //translateToLanguage = UserPreferences.getTranslateToLanguage()
        
    }
    
    // MARK: Conforming to UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .Center
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select your desired Language"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let languageCell = tableView.dequeueReusableCellWithIdentifier(SBIdentifiers.languageTableViewCell.rawValue, forIndexPath: indexPath)
        let language = languages[indexPath.row]
        languageCell.textLabel?.text = language.name
        
        return languageCell
    }
    
    // MARK: Conforming to UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Saving user's choice
        UserPreferences.saveTranslateToLanguage(languages[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
