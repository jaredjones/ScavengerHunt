//
//  AddViewController.swift
//  Scavenger Hunt
//
//  Created by Apple on 6/4/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var addedItemTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissSelf(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "DoneItem" {
            if addedItemTextField.text!.isEmpty {
                let alert = UIAlertController(title: "No Item Entered", message: "You must specify an item before proceeding!", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return false
            }
            return true
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DoneItem" {
            addedItemTextField.resignFirstResponder()
            let listViewController = (segue.destinationViewController as! ListViewController)
            let newItem = ScavengerHuntItem(addedItemTextField.text!)
            listViewController.newlyAddedItem = newItem
        }
    }
}

