//
//  ParsingHelper.swift
//  Collection View, Instagram
//
//  Created by Nivardo Ibarra on 12/17/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import Foundation

// Step 1
protocol ParsingHelperDelegate {
    func parsingHelper(itemsSection: Book)
}

class ParsingHelper: NSObject {
    // Step 2
    var delegate: ParsingHelperDelegate?
    
    // Step 4.1
    func parseData(isbnBook: String, data: NSData) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves)
            let dictionary1 = json as! NSDictionary
            
            let isbn = "ISBN:" + isbnBook
            var author = [String]()
            if dictionary1[isbn] != nil {
                let dictionary2 = dictionary1[isbn] as! NSDictionary
                
                let title = dictionary2["title"] as! NSString as String

                let responseData: NSArray? = dictionary2.valueForKey("authors") as? NSArray
                if responseData != nil {
                    for currentAuthor in responseData! {
                        let cAuthor: NSDictionary = currentAuthor as!NSDictionary;
                        author.append(cAuthor.valueForKey("name") as! String)
                    }
                }
                
                let image: String? = dictionary2.valueForKey("cover")?.valueForKey("medium") as? String
                dispatch_async(dispatch_get_main_queue(),{
                    let book = Book(title: title, authors: author, isbn: isbnBook, imageUrl: image)
                    self.delegate!.parsingHelper(book)
                });
                
            } else {
                let book = Book(title: "", authors: author, isbn: "", imageUrl: "")
                self.delegate!.parsingHelper(book)
            }

            } catch {
                // Handle exception
                return
            }
        });
    }
}