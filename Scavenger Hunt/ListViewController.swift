//
//  ListViewController.swift
//  Scavenger Hunt
//
//  Created by Apple on 6/4/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var lastItemPressedIndex: Int?
    var newlyAddedItem:ScavengerHuntItem?
    let itemsManager: ItemsManager = ItemsManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func seguedFromAddViewController(segue: UIStoryboardSegue) {
        if let item = newlyAddedItem {
            itemsManager.itemsList.append(item)
            self.itemsManager.save()
            //Slow:
            //     self.tableView.reloadData()
            let indexPath = NSIndexPath(forRow: itemsManager.itemsList.count - 1, inSection: 0)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                NSThread.sleepForTimeInterval(0.4)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                });
            })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsManager.itemsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCell", forIndexPath: indexPath)
        let item = itemsManager.itemsList[indexPath.row]
        
        
        cell.textLabel?.text = item.name
        cell.imageView?.image = item.photo
        
        if item.completed {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        lastItemPressedIndex = indexPath.row
        if itemsManager.itemsList[lastItemPressedIndex!].completed {
            let alert = UIAlertController(title: "Whatcha Wanna Do?", message: "Specify the action you wish to take.", preferredStyle: .ActionSheet)
            let replaceAction = UIAlertAction(title: "Unfind Item", style: .Default, handler: { (UIAlertAction) in
                self.itemsManager.itemsList[self.lastItemPressedIndex!].photo = nil
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            let deleteAction = UIAlertAction(title: "Delete Item", style: .Destructive, handler: { (UIAlertAction) in
                self.itemsManager.itemsList.removeAtIndex(self.lastItemPressedIndex!)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            let backAction = UIAlertAction(title: "Back", style: .Cancel, handler: nil)
            
            alert.addAction(replaceAction)
            alert.addAction(deleteAction)
            alert.addAction(backAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .CurrentContext
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            picker.sourceType = .Camera
        } else {
            picker.sourceType = .PhotoLibrary
        }
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        itemsManager.itemsList[lastItemPressedIndex!].photo = img
        self.itemsManager.save()
        
        let rowIndexPath = NSIndexPath(forRow: lastItemPressedIndex!, inSection: 0)
        
        self.tableView.reloadRowsAtIndexPaths([rowIndexPath], withRowAnimation: .Automatic)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}