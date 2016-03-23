//
//  FavoritesViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 03/03/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import UIKit

import CoreData

class FavoritesViewController : BaseViewController,
    UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{

    @IBOutlet var favoritesTable: UITableView!

    @IBOutlet weak var editDoneButton: UIBarButtonItem!
    @IBOutlet weak var deleteAllButton: UIBarButtonItem!

    lazy var favoritesController : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Favorite")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "originalLanguage == %@ and translateToLanguage = %@",
            self.originalLanguage, self.savedTranslateToLanguage!)

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    } ()

    override func viewDidLoad() {

        super.viewDidLoad()

        favoritesTable.delegate = self
        favoritesTable.dataSource = self

        navigationItem.title = "Your Favorites"

        deleteAllButton.enabled = false


        if let _ = savedTranslateToLanguage {
            let _ = try? favoritesController.performFetch()
            favoritesController.delegate = self
            favoritesTable.reloadData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tryResetEditMode()
    }

    
    @IBAction func activateEditMode(sender: AnyObject) {
        toggleEditMode()
    }

    @IBAction func deleteAll(sender: AnyObject) {
        favoritesController.fetchedObjects?.forEach {
            sharedContext.deleteObject($0 as! NSManagedObject)
        }
        saveContext()
    }

    func toggleEditMode() {
        let editable = favoritesController.fetchedObjects!.count > 0
        editDoneButton.enabled = editable
        favoritesTable.editing = editable && !favoritesTable.editing
        editDoneButton.title = (editable && favoritesTable.editing) ? "Done" : "Edit"
        deleteAllButton.enabled = editable && favoritesTable.editing
    }

    func tryResetEditMode() {
        if favoritesController.fetchedObjects!.count == 0 {
            editDoneButton.enabled = false
            deleteAllButton.enabled = false
            editDoneButton.title = "Edit"
            favoritesTable.editing = false
        } else {
            editDoneButton.enabled = true
        }
    }

    // MARK: Conforming to NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        favoritesTable.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        favoritesTable.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {

        switch type {
        case .Delete:
            favoritesTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Insert:
            favoritesTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        default:
            break
            // NOOP
        }
    }

    // MARK: Conforming to UITableViewDelegate and UITableViewDataSource protocol
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesController.fetchedObjects?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let favoriteCell = tableView.dequeueReusableCellWithIdentifier("favoriteViewCell", forIndexPath: indexPath)
        let favoriteEntry = favoritesController.objectAtIndexPath(indexPath) as! Favorite
        //favoriteCell.configureCell(favoriteEntry.originalPhrase!, translatedText: favoriteEntry.translateToLanguage,
        //    liked: true, language: favoriteEntry.translateToLanguage!, row: indexPath.row)
        //favoriteCell.likeCallback = nil
        favoriteCell.textLabel?.text = favoriteEntry.translatedPhrase
        return favoriteCell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let objectToDelete = favoritesController.objectAtIndexPath(indexPath)
            sharedContext.deleteObject(objectToDelete as! NSManagedObject)
            saveContext()
        }
        
    }



}