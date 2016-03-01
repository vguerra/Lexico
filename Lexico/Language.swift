//
//  Language.swift
//  Lexico
//
//  Created by Victor Guerra on 11/12/15.
//  Copyright © 2015 Victor Guerra. All rights reserved.
//

import Foundation
import CoreData

class Language : NSManagedObject {
    // Language code according to ISO 639
    @NSManaged var code: String;
    // Language flag
    @NSManaged var emoji: String;
    // Language name
    @NSManaged var name: String;
    // Language tag according to BCP 47
    @NSManaged var tag : String;
    
    var nameAndFlag : String {
        return "\(name) \(emoji)"
    }
    
    init (code: String, tag: String, name: String, emoji: String, context : NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Language", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.code = code
        self.tag = tag
        self.name = name
        self.emoji = emoji
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
