//
//  UserPreferences.swift
//  Lexico
//
//  Created by Victor Guerra on 14/12/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import Foundation

class UserPreferences {
    // path for file holding prefered language
    private static let preferencesFilePath : String = {
        let manager = NSFileManager.defaultManager()
        let url : NSURL = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return url.URLByAppendingPathComponent("preferedLanguage").path!
    } ()
    
    static func saveTranslateToLanguageIndex(index: Int) {
        NSKeyedArchiver.archiveRootObject(index, toFile: preferencesFilePath)
    }
    
    static func getTranslateToLanguageIndex() -> Int {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(preferencesFilePath) as? Int) ?? 0
    }
    
    static func getTranslateToLanguage() -> Language? {
        let storedIndex = getTranslateToLanguageIndex()
        return storedIndex > -1 ?
            LanguagesManager.sharedInstace.otherLanguages[storedIndex] : nil
        
    }
}
