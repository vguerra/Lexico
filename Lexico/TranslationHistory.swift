//
//  TranslationHistory.swift
//  Lexico
//
//  Created by Victor Guerra on 29/02/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import Foundation
import CoreData

class TranslationHistory : NSManagedObject {

    @NSManaged var date : NSDate?
    @NSManaged var word : String?
    @NSManaged var originalLanguage : Language?
    @NSManaged var translateToLanguage : Language?

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init (date : NSDate, word : String, context : NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("TranslationHistory", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.date = date
        self.word = word
    }
}