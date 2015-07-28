//
//  DetailVC.swift
//  ImagePicker
//
//  Created by Dany Cabrera Vargas on 27/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import UIKit

// Meme Detail View Controller
class DetailVC: UIViewController {
	var imgDetailImage: UIImage!
	var meme: Meme!
	var indexMeme: Int!

	@IBOutlet weak var imgDetail: UIImageView!

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		imgDetail.image = meme.memedImage
	}

	// edit button -> edit this meme
	@IBAction func editMeme(sender: UIBarButtonItem) {
		var evc = storyboard?.instantiateViewControllerWithIdentifier("editor") as! MemeEditorVC
		evc.loadWithIndex = indexMeme
		presentViewController(evc, animated: true, completion: nil)
	}

	// delete button -> remove meme from storage
	@IBAction func deleteMeme(sender: UIBarButtonItem) {
		let object = UIApplication.sharedApplication().delegate
		let appDelegate = object as! AppDelegate
		appDelegate.memes.removeAtIndex(indexMeme)
		navigationController?.popViewControllerAnimated(true)
	}
}