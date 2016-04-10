//
//  BaseViewController.swift
//  Lexico
//
//  Created by Victor Guerra on 20/02/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

import UIKit
import CoreData

// SLViewController implements basic functionality which is
// commnly used among all ViewControllers in this application

class BaseViewController : UIViewController {
    
    var activityIndicator : UIActivityIndicatorView! = nil
    var activityView : UIView! = nil
    var activityLabel : UILabel! = nil

    let originalLanguage = LanguagesManager.sharedInstace.originalLanguage

    var savedTranslateToLanguage : Language? {
        return UserPreferences.getTranslateToLanguage()
    }

    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }

    func saveContext() {
        CoreDataStackManager.sharedInstance.saveContext()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIElements()
    }
    
    // MARK: Activity view life cycle
    func setUpUIElements() {
        let sideLength:CGFloat = 170.0
        activityView = UIView(frame: CGRectMake(self.view.bounds.width/2 - sideLength/2,
            self.view.bounds.height/2 - sideLength/2, sideLength, sideLength))
        activityView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        activityView.clipsToBounds = true;
        activityView.layer.cornerRadius = 10.0;
        activityView.hidden = true
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.frame = CGRectMake(0, 0, activityView.bounds.size.width, activityView.bounds.size.height)
        activityIndicator.hidesWhenStopped = true
        
        
        
        activityLabel = UILabel(frame: CGRectMake(20, 115, 130, 22))
        activityLabel.font = UIFont(name: "Roboto-Medium", size: 16.0)
        activityLabel.backgroundColor = UIColor.clearColor()
        activityLabel.textColor = UIColor.whiteColor()
        activityLabel.adjustsFontSizeToFitWidth = true
        activityLabel.textAlignment = NSTextAlignment.Center
        
        activityView.addSubview(activityLabel)
        activityView.addSubview(activityIndicator)
        self.view.addSubview(activityView)
    }
    
    func startActivityAnimation(message message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityLabel.text = message
            self.activityView.hidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivityAnimation() {
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            self.activityView.hidden = true
        }
    }    
}


// Extending all UIViewControolers to have a method
// that displays a nice UIAlertController
extension UIViewController {
    func showWarning(title title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK, Got it! 👍", style:UIAlertActionStyle.Default, handler: nil)
        alert.addAction(OKAction)
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

