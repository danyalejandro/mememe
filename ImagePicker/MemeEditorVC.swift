//
//  MemeEditorVC.swift
//  ImagePicker
//
//  Created by Dany Cabrera Vargas on 28/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import UIKit

// View controller for the Meme Editor
class MemeEditorVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	var delTxtTop = TextFieldDelegate(defText: "TOP")
	var delTxtBottom = TextFieldDelegate(defText: "BOTTOM")
	var viewIsShifted = false
	var createdMeme: Meme!
	var loadWithIndex: Int? = nil // if not nil then load this meme

	@IBOutlet weak var img: UIImageView!
	@IBOutlet weak var btPhoto: UIBarButtonItem!
	@IBOutlet weak var txtTop: UITextField!
	@IBOutlet weak var txtBottom: UITextField!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var btnShare: UIBarButtonItem!
	@IBOutlet weak var navBar: UINavigationBar!


	override func viewDidLoad() {
		super.viewDidLoad()
		btPhoto.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		txtTop.delegate = delTxtTop
		txtBottom.delegate = delTxtBottom
		btnShare.enabled = false

		// Apply special text format to textFields
		let memeTextAttributes = [
			NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
			NSStrokeColorAttributeName: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
			NSStrokeWidthAttributeName: -3.0
		]
		txtTop.defaultTextAttributes = memeTextAttributes
		txtTop.textAlignment = NSTextAlignment.Center
		txtTop.autocapitalizationType = UITextAutocapitalizationType.Words
		txtBottom.defaultTextAttributes = memeTextAttributes
		txtBottom.textAlignment = NSTextAlignment.Center
		txtBottom.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if (loadWithIndex != nil) {
			loadMeme(loadWithIndex)
			loadWithIndex = nil
		}
		else {
			txtTop.text = "TOP"
			txtBottom.text = "BOTTOM"
		}
		subscribeToKeyboardNotifications()

	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		unsubscribeFromKeyboardNotifications()
	}

	func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
	}

	func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}

	func keyboardWillShow(notification: NSNotification) {
		if (txtBottom.isFirstResponder()) {
			let height = getKeyboardHeight(notification)
			view.frame.origin.y -= height
			viewIsShifted = true
		}
	}

	func keyboardWillHide(notification: NSNotification) {
		if (viewIsShifted) {
			view.frame.origin.y = 0
			viewIsShifted = false
		}
	}

	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		return keyboardSize.CGRectValue().height
	}

	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		img.image = image
		btnShare.enabled = true
		dismissViewControllerAnimated(true, completion: nil)
	}

	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	// Creates and returns the Meme Image
	func generateMemedImage() -> UIImage {
		navBar.hidden = true
		toolbar.hidden = true

		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
		let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		navBar.hidden = false
		toolbar.hidden = false
		return memedImage
	}

	// Stores the current meme as an object in the appDelegate memes array
	func storeMeme(imgMeme: UIImage!) {
		let object = UIApplication.sharedApplication().delegate
		let appDelegate = object as! AppDelegate

		let createdMeme = Meme(
			textTop: txtTop.text!,
			textBottom: txtBottom.text!,
			image: img.image,
			memedImage: imgMeme
		)

		appDelegate.memes.append(createdMeme)
	}

	// Loads the meme at given index
	func loadMeme(index: Int!) {
		let object = UIApplication.sharedApplication().delegate
		let appDelegate = object as! AppDelegate

		let loadedMeme = appDelegate.memes[index]
		txtTop.text = loadedMeme.textTop
		txtBottom.text = loadedMeme.textBottom
		img.image = loadedMeme.image
		btnShare.enabled = true
	}

	// Album button -> Show image picker
	@IBAction func pickImage(sender: UIBarButtonItem) {
		var ivc = UIImagePickerController()
		ivc.delegate = self
		presentViewController(ivc, animated: true, completion: nil)
	}

	// Picture button -> obtain image from camera
	@IBAction func takePicture(sender: UIBarButtonItem) {
		var ivc = UIImagePickerController()
		ivc.delegate = self
		ivc.sourceType = UIImagePickerControllerSourceType.Camera
		presentViewController(ivc, animated: true, completion: nil)
	}

	// Share Button -> Show Activity View
	@IBAction func shareMeme(sender: UIBarButtonItem) {
		let imgMeme = generateMemedImage()

		var avc = UIActivityViewController(activityItems: [imgMeme], applicationActivities: nil)
		avc.completionWithItemsHandler = {activity, success, items, error in
			// Handle "Cancel" button
			if !success {
				return
			}

			// If activity was a success, store the meme and return to Sent Memes
			self.storeMeme(imgMeme)
			self.dismissViewControllerAnimated(true, completion: nil)
		}

		presentViewController(avc, animated: true, completion: nil)
	}

	// Cancel button -> dismiss view
	@IBAction func dismissView(sender: UIBarButtonItem) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}

