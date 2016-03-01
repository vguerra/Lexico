//
//  Favorite.swift
//  Lexico
//
//  Created by Victor Guerra on 29/02/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import Foundation
import CoreData

class Favorite : NSManagedObject {
    @NSManaged var originalPhrase : String?
    @NSManaged var translatedPhrase : String?
    @NSManaged var originalLanguage : Language?
    @NSManaged var translateToLanguage : Language?

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init (originalPhrase : String, translatedPhrase : String, context : NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Favorite", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.originalPhrase = originalPhrase
        self.translatedPhrase = translatedPhrase
    }
}