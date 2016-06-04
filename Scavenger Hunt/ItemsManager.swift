//
//  ItemsManager.swift
//  Scavenger Hunt
//
//  Created by Apple on 6/4/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

class ItemsManager {
    var itemsList: [ScavengerHuntItem] = []
    
    init() {
        if let theArchivePath = archivePath() {
            if NSFileManager.defaultManager().fileExistsAtPath(theArchivePath) {
                itemsList = NSKeyedUnarchiver.unarchiveObjectWithFile(theArchivePath) as! [ScavengerHuntItem]
                return
            }
            return
        }
        assertionFailure("ArchivePath is nil")
    }
    
    func archivePath() -> String? {
        let directoryList = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if let documentsPath = directoryList.first {
            return documentsPath + "/ScavengerHuntItems"
        }
        assertionFailure("Could not find Document Directory, or invalid access to directory")
        return nil
    }
    
    func save() {
        if let theArchivePath = archivePath() {
            if NSKeyedArchiver.archiveRootObject(itemsList, toFile: theArchivePath) {
                print("Save Successfully")
                return
            }
            assertionFailure("Could not save to the archive path: \(theArchivePath)")
        }
        assertionFailure("ArchivePath is nil")
    }
}