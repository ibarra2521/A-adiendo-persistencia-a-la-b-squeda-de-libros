//
//  SearchDetailVC.swift
//  Uso de vistas jerárquicas
//
//  Created by Nivardo Ibarra on 12/19/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import UIKit
import CoreData

class SearchDetailVC: UIViewController, NSFetchedResultsControllerDelegate, WebserviceHelperDelegate {
    @IBOutlet weak var lblAuthors: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvCover: UIImageView!
    @IBOutlet weak var txtfSearchBook: UITextField!
    
    let connection = WebserviceHelper()
    var books: [Book] = [Book]()
    var book: BookEntity? = nil
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtfSearchBook.clearButtonMode = .WhileEditing
        self.connection.delegate = self
        if book != nil {
            lblTitle.text = book?.title
            lblAuthors.text = book?.authors
            txtfSearchBook.text = book?.isbn
            imgvCover.image = UIImage(data: (book?.image)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func txtfIsbn(sender: UITextField) {
        sender.resignFirstResponder()
        let isbn = sender.text
        if isbn!.characters.count > 0 {
            resetElements()
            requestServer()
        }else {
            showAlertMessage("Warning", message: "You must enter the ISBN of the book", owner: self)
        }
    }
    
    func requestServer() {
        let reachability = Reachability()
        if reachability.isConnectedToNetwork() {
            self.connection.loadDataFromWebService(self.txtfSearchBook.text!)
        }else {
            showAlertMessage("Error", message: "There are problems connecting to the Internet", owner: self)
        }
    }

    func createNewBook() {
        let entityDescription = NSEntityDescription.entityForName("BookEntity", inManagedObjectContext: managedObjectContext)
        let book = BookEntity(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        book.title = lblTitle.text
        book.isbn = txtfSearchBook.text
        book.authors = lblAuthors.text
        book.image = UIImagePNGRepresentation(imgvCover.image!)
        do {
            try managedObjectContext.save()
        }catch {
            abort()
        }
    }
    
    func showAlertMessage (title: String, message: String, owner:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // THREE (3.4)
    func webserviceHelper (book: Book) {
        if book.isbn != "" {
            books.append(book)
            self.lblTitle.text = book.title
            self.lblAuthors.text = book.authors
            
            if book.imageUrl != nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let imageData = NSData(contentsOfURL: NSURL(string:book.imageUrl!)!);
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imgvCover.image = UIImage(data: imageData!)
                        self.createNewBook()
                    })
                })
            }else {
                self.imgvCover.image = UIImage(named: "no found")
                self.createNewBook()
            }
        }else {
            showAlertMessage("MESSAGE!!!", message: "ISBN not found", owner: self)
            resetElements()
        }
    }
    
    func resetElements() {
        self.lblTitle.text = ""
        self.lblAuthors.text = ""
        self.imgvCover.image = UIImage(named: "no found")
    }
}
