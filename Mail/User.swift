//
//  User.swift
//  Mail
//
//  Created by A K on 11/9/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit
import CoreData

@objc(User)
public class User: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String
    @NSManaged public var password: String
}
