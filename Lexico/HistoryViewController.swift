//
//  HistoryViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 01/03/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController : BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    NSFetchedResultsControllerDelegate {
    
    @IBOutlet var historyTable: UITableView!

    @IBOutlet weak var editDoneButton: UIBarButtonItem!
    @IBOutlet weak var deleteAllButton: UIBarButtonItem!

    lazy var historyController : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "TranslationHistory")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "originalLanguage == %@ and translateToLanguage = %@",
            self.originalLanguage, self.savedTranslateToLanguage!)

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    } ()

    let dateFormater = NSDateFormatter()

    override func viewDidLoad() {

        super.viewDidLoad()

        historyTable.delegate = self
        historyTable.dataSource = self

        dateFormater.dateStyle = .ShortStyle
        dateFormater.timeStyle = .ShortStyle

        navigationItem.title = "Your Translation history"
        deleteAllButton.enabled = false

        if let _ = savedTranslateToLanguage {
            let _ = try? historyController.performFetch()
            historyController.delegate = self
            historyTable.reloadData()
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
        historyController.fetchedObjects?.forEach {
            sharedContext.deleteObject($0 as! NSManagedObject)
        }
        saveContext()
    }

    func toggleEditMode() {
        let editable = historyController.fetchedObjects!.count > 0
        editDoneButton.enabled = editable
        historyTable.editing = editable && !historyTable.editing
        editDoneButton.title = (editable && historyTable.editing) ? "Done" : "Edit"
        deleteAllButton.enabled = editable && historyTable.editing
    }

    func tryResetEditMode() {
        if historyController.fetchedObjects!.count == 0 {
            editDoneButton.enabled = false
            deleteAllButton.enabled = false
            editDoneButton.title = "Edit"
            historyTable.editing = false
        } else {
            editDoneButton.enabled = true
        }
    }

    // MARK: Conforming to NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        historyTable.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        historyTable.endUpdates()
        tryResetEditMode()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {

        switch type {
        case .Delete:
            historyTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Insert:
            historyTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        default:
            break
        // NOOP
        }
    }

    // MARK: Conforming to UITableViewDelegate and UITableViewDataSource protocol
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyController.fetchedObjects?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let historyCell = tableView.dequeueReusableCellWithIdentifier("historyViewCell", forIndexPath: indexPath)
        let translationEntry = historyController.objectAtIndexPath(indexPath) as! TranslationHistory

        historyCell.textLabel?.text = "\(translationEntry.originalLanguage!.nameAndFlag ) --> \(translationEntry.translateToLanguage!.nameAndFlag) of \(translationEntry.word!)"

        historyCell.detailTextLabel?.text = dateFormater.stringFromDate(translationEntry.date!)
        return historyCell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let objectToDelete = historyController.objectAtIndexPath(indexPath)
            sharedContext.deleteObject(objectToDelete as! NSManagedObject)
            saveContext()
        }

    }
}
