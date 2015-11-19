//
//  TableViewController.swift
//  Super
//
//  Created by Bob Pascazio on 11/18/15.
//  Copyright © 2015 NYCDA. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var array: [PFObject] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let query = PFQuery(className: "TestObject")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if (error == nil) {
                self.array.appendContentsOf(objects!)
                print(self.array)
                self.tableView.reloadData()
            }else {
                print(error?.userInfo)
            }
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
    }
    
    func refresh(sender:AnyObject)
    {
        let query = PFQuery(className: "TestObject")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if (error == nil) {
                self.array=objects!
                print(self.array)
                self.refreshControl!.endRefreshing()
                self.tableView.reloadData()
            }else {
                print(error?.userInfo)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        
        let foo = array[indexPath.row].valueForKey("foo") as! String?
        cell.textLabel?.text = foo
        
        let available = array[indexPath.row].valueForKey("available") as! Bool?
        
        if let available_ = available {
            
            if available_ {
                cell.backgroundColor = UIColor.greenColor()
            } else {
                cell.backgroundColor = UIColor.yellowColor()
            }
            
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let item = array[indexPath.row]
        let available = item.valueForKey("available") as! Bool?
        var newStatus = true
        if let available_ = available {
            if available_ {
                newStatus = false
            } else {
                newStatus = true
            }
        }
        item["available"] = newStatus
        item.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been updated.")
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
