//
//  Book.swift
//  Tarea: Petición al servidor openlibrary.org
//
//  Created by Nivardo Ibarra on 12/18/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import UIKit

class Book {
    var title: String
    var isbn: String
    var authors: String
    var imageUrl: String?
    var images: UIImage?
    
    init(title: String, authors: String, isbn: String, imageUrl: String?) {
        self.title = title
        self.authors = authors
        self.isbn = isbn
        self.imageUrl = imageUrl
    }
}
