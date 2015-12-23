//
//  BookEntity+CoreDataProperties.swift
//  Uso de vistas jerárquicas
//
//  Created by Nivardo Ibarra on 12/19/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BookEntity {

    @NSManaged var title: String?
    @NSManaged var isbn: String?
    @NSManaged var authors: String?
    @NSManaged var imageUrl: String?
    @NSManaged var image: NSData?

}
