//
//  MemeTableViewController.swift
//  MemeMe2
//
//  Created by Roman Kolodzie on 3/21/16.
//  Copyright © 2016 RomanKolodzie. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    //Lifecycle functions
    
    override func viewWillAppear(animated: Bool) {
        tableView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Protocol
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath)
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.newMemeImage
        cell.textLabel?.text = meme.textTop
        cell.detailTextLabel?.text = meme.textBottom
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailView = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailView.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailView, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}
