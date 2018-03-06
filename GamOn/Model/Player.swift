//
//  Player.swift
//  GamOn
//
//  Created by Shahla Almasri Hafez on 2/21/18.
//  Copyright © 2018 MrRobot. All rights reserved.
//

import UIKit
import Contacts
import CoreData

class Player {
    var identifier = ""
    var firstName = ""
    var lastName = ""
    
    ///
    ///
    ///
    init() { }
    
    ///
    ///
    ///
    init(contact: CNContact) {
        identifier = contact.identifier
        firstName = contact.givenName
        lastName = contact.familyName
    }   
}
