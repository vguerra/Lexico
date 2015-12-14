//
//  Language.swift
//  Lexico
//
//  Created by Victor Guerra on 11/12/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import Foundation

class Language : NSObject, NSCoding {
    let code: String;
    let name: String;
    let emoji: String;
    
    init (code: String, name: String, emoji: String) {
        self.code = code
        self.name = name
        self.emoji = emoji
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.code = aDecoder.decodeObjectForKey("code") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.emoji = aDecoder.decodeObjectForKey("emoji") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(emoji, forKey: "emoji")
    }
}