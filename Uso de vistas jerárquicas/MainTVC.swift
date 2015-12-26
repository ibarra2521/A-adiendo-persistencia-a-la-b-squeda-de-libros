//
//  MainTVC.swift
//  Uso de vistas jerárquicas
//
//  Created by Nivardo Ibarra on 12/19/15.
//  Copyright © 2015 Nivardo Ibarra. All rights reserved.
//

import UIKit
import CoreData

class MainTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultsController = NSFetchedResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = getFetchResultsController()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to perform initial fetch.")
            abort()
        }
        self.tableView.rowHeight = 60
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "orange-bg"))
        self.tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        fetchedResultsController = getFetchResultsController()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to perform initial fetch.")
            abort()
        }
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (fetchedResultsController.sections?.count)!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (fetchedResultsController.sections?[section].numberOfObjects)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell
        cell.imageView?.layer.masksToBounds = true;
        cell.imageView?.layer.cornerRadius = CGRectGetWidth((cell.imageView?.bounds)!)/1

        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.clearColor()
        }else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.detailTextLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
        let book =  fetchedResultsController.objectAtIndexPath(indexPath) as! BookEntity
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.isbn
        cell.detailTextLabel?.text = "\(self.getAuthors(book)) ISBN: \(book.isbn!)"
        cell.imageView?.image = UIImage(data: (book.image)!)
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject: NSManagedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        do {
            try managedObjectContext.save()
        }catch {
            print("Failed to save.")
            abort()
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detail" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let itemController: SearchDetailVC = segue.destinationViewController as! SearchDetailVC
            let book: BookEntity = fetchedResultsController.objectAtIndexPath(indexPath!) as! BookEntity
            itemController.book = book
        }
    }

    func fetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "BookEntity")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func getFetchResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func getAuthors(book: BookEntity) ->String {
        let authorEntity = book.valueForKey("has") as! Set<NSObject>
        var authors = ""
        for authorTemp in authorEntity {
            authors += authorTemp.valueForKey("name") as! String + " - "
        }
        return authors
    }
}
