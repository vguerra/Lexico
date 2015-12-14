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
    
    static func saveTranslateToLanguage(language: Language) {
        NSKeyedArchiver.archiveRootObject(language, toFile: preferencesFilePath)
    }
    
    static func getTranslateToLanguage() -> Language? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(preferencesFilePath) as? Language
    }
}
