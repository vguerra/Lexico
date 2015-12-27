//
//  Language.swift
//  Lexico
//
//  Created by Victor Guerra on 11/12/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import Foundation

class Language : NSObject, NSCoding {
    // Language code according to ISO 639
    let code: String;
    // Language tag according to BCP 47
    let tag : String;
    // Language name
    let name: String;
    // Language flag
    let emoji: String;
    
    init (code: String, tag: String, name: String, emoji: String) {
        self.code = code
        self.tag = tag
        self.name = name
        self.emoji = emoji
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.code = aDecoder.decodeObjectForKey("code") as! String
        self.tag = aDecoder.decodeObjectForKey("tag") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.emoji = aDecoder.decodeObjectForKey("emoji") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(tag, forKey: "tag")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(emoji, forKey: "emoji")
    }
}