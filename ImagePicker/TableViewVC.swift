//
//  TableViewVC.swift
//  ImagePicker
//
//  Created by Dany Cabrera Vargas on 27/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import UIKit

// Sent Memes: Table View Controller
class TableViewVC: UITableViewController, UITableViewDelegate, UITableViewDataSource {
	var memes: [Meme]!
	var selectedIndex: Int!

	// plus button -> show meme editor
	@IBAction func showEditor(sender: UIBarButtonItem) {
		var evc = storyboard?.instantiateViewControllerWithIdentifier("editor") as! MemeEditorVC
		presentViewController(evc, animated: true, completion: nil)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		// load & refresh table contents
		let object = UIApplication.sharedApplication().delegate
		let appDelegate = object as! AppDelegate
		memes = appDelegate.memes
		tableView.reloadData()
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "segDetail1") {
			var dvc = segue.destinationViewController as! DetailVC
			dvc.meme = memes[selectedIndex]
			dvc.indexMeme = selectedIndex
		}
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memes.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! UITableViewCell
		cell.textLabel?.text = memes[indexPath.row].textTop
		cell.detailTextLabel?.text = memes[indexPath.row].textBottom
		cell.imageView?.image = memes[indexPath.row].memedImage
		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedIndex = indexPath.row
		performSegueWithIdentifier("segDetail1", sender: self)
	}
}
