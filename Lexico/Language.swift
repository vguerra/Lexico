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

class LanguagesManager {
    
    
    private static let LanguagesCount = 2
    private static let Entity = "Language"
    internal static let sharedInstace = LanguagesManager()
    
    private lazy var fetchOriginalLanguage : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: Entity)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "code == %@", "eng")
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    }()

    private lazy var fetchOtherLanguages : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: Entity)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "code != %@", "eng")
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    }()

    private var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    var originalLanguage : Language {
        return fetchOriginalLanguage.fetchedObjects!.first as! Language
    }
    
    var otherLanguages : [Language] {
        return fetchOtherLanguages.fetchedObjects as! [Language]
    }

    private init() {
        loadLanguages()
    }
    
    // MARK: Core Data Convenience.

    private func loadLanguages() {
        do {
            try fetchOtherLanguages.performFetch()
            try fetchOriginalLanguage.performFetch()
            if fetchOtherLanguages.fetchedObjects?.count == 0 {
                populateLanguages()
                try fetchOtherLanguages.performFetch()
                try fetchOriginalLanguage.performFetch()
            }
        } catch let error as NSError  {
                print(error)
        }
    }
    
    private func populateLanguages() {
        let languages : [[String]] = [
            ["eng", "en_US", "English", "🇬🇧"],
            ["spa", "es_ES", "Spanish", "🇪🇸"]
        ]
        
        let _ = languages.map() {
            Language(code: $0[0], tag: $0[1], name: $0[2], emoji: $0[3], context: sharedContext)
        }
        debugPrint("Created languages")
        CoreDataStackManager.sharedInstance.saveContext()
    }
}