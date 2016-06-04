//
//  ScavengerHuntItem.swift
//  Scavenger Hunt
//
//  Created by Apple on 6/4/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class ScavengerHuntItem: NSObject, NSCoding {
    let name:String
    var photo:UIImage?
    var completed:Bool {
        return photo != nil
    }
    
    let nameKey = "name"
    let photoKey = "photo"
    
    init(_ name: String) {
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(nameKey) as! String
        photo = aDecoder.decodeObjectForKey(photoKey) as? UIImage
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: nameKey)
        if let thePhoto = photo {
            aCoder.encodeObject(thePhoto, forKey: "photo")
        }
    }
}