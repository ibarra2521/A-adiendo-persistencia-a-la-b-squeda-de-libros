//
//  WebserviceHelper.swift
//  Collection View, Instagram
//
//  Created by Nivardo Ibarra on 12/17/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import Foundation

// ONE
protocol WebserviceHelperDelegate {
    func webserviceHelper(book: Book)
}
// Step 3.1
class WebserviceHelper: ParsingHelperDelegate {
    // TWO
    var delegate: WebserviceHelperDelegate?
    // Step 3.3.1
    var parsingHelper = ParsingHelper()
    
    init() {
        // Step 3.3.2
        parsingHelper.delegate = self
    }
    // FOUR (4.1)
    func loadDataFromWebService(isbnBook: String) {
        let session = NSURLSession.sharedSession()
        let urlWebService = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbnBook)"
        let url = NSURL(string: urlWebService)
        
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                // Step 4.2
                // FOUR (4.3)
                self.parsingHelper.parseData(isbnBook, data: data!);
            }
        }
        task.resume()
    }
    
    // Step 3.2
    func parsingHelper(book: Book) {
        self.delegate?.webserviceHelper(book)
    }
}