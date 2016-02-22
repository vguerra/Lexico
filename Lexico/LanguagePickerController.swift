//
//  LanguagePickerController.swift
//  Lexico
//
//  Created by Victor Guerra on 09/12/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import UIKit
import CoreData

// TODO: This has to be moved somewhere else

enum SBIdentifiers : String {
    case languageTableViewCell = "languageCell"
}

class LanguagePickerController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var languagesTableView: UITableView!
    
    var translateToLanguage : Language?
    let LanguageManager = LanguagesManager.sharedInstace
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagesTableView.dataSource = self
        languagesTableView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        translateToLanguage = UserPreferences.getTranslateToLanguage()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: IBActions
    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageManager.otherLanguages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let languageCell = tableView.dequeueReusableCellWithIdentifier(SBIdentifiers.languageTableViewCell.rawValue, forIndexPath: indexPath)
        let language = LanguageManager.otherLanguages[indexPath.row]
        languageCell.textLabel?.text = language.nameAndFlag
        
        if let chosenLanguage = translateToLanguage
            where chosenLanguage.code == language.code {
                tableView.selectRowAtIndexPath(indexPath, animated: false,
                    scrollPosition: UITableViewScrollPosition.None)
        }
        return languageCell
    }
    
    // MARK: Conforming to UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Saving user's choice
        UserPreferences.saveTranslateToLanguage(LanguageManager.otherLanguages[indexPath.row])
        dismissController(tableView)
    }
    
}
