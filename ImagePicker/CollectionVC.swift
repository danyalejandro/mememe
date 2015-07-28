//
//  CollectionVC.swift
//  ImagePicker
//
//  Created by Dany Cabrera Vargas on 27/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import UIKit

// Sent Memes: Collection View Controller
class CollectionVC: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	var memes: [Meme]!
	var selectedIndex: Int!

	// plus button -> show meme editor
	@IBAction func showEditor(sender: UIBarButtonItem) {
		var evc = storyboard?.instantiateViewControllerWithIdentifier("editor") as! MemeEditorVC
		presentViewController(evc, animated: true, completion: nil)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		// load & refresh collection contents
		let object = UIApplication.sharedApplication().delegate
		let appDelegate = object as! AppDelegate
		memes = appDelegate.memes
		collectionView?.reloadData()
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "segDetail2") {
			var dvc = segue.destinationViewController as! DetailVC
			dvc.meme = memes[selectedIndex]
			dvc.indexMeme = selectedIndex
		}
	}

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell = collectionView.dequeueReusableCellWithReuseIdentifier("colCell", forIndexPath: indexPath) as! UICollectionViewCell
		let meme = memes[indexPath.item]

		let imageView = UIImageView(image: meme.memedImage)
		cell.backgroundView = imageView
		return cell
	}

	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		selectedIndex = indexPath.row
		performSegueWithIdentifier("segDetail2", sender: self)
	}




}