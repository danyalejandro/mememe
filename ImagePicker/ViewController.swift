//
//  ViewController.swift
//  ImagePicker
//
//  Created by Dany Cabrera Vargas on 27/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import UIKit

// View controller for the 
class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

	@IBOutlet weak var img: UIImageView!
	@IBOutlet weak var btPhoto: UIBarButtonItem!
	@IBOutlet weak var txtTop: UITextField!
	@IBOutlet weak var txtBottom: UITextField!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var btnShare: UIBarButtonItem!
	@IBOutlet weak var navBar: UINavigationBar!

	var delTxtTop = TextFieldDelegate()
	var viewIsShifted = false
	var createdMeme: Meme!

	override func viewDidLoad() {
		super.viewDidLoad()
		btPhoto.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		txtTop.delegate = delTxtTop
		txtBottom.delegate = delTxtTop
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
		txtTop.text = "TOP"
		txtBottom.text = "BOTTOM"
		self.subscribeToKeyboardNotifications()

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
			self.view.frame.origin.y -= height
			viewIsShifted = true
		}
	}
	func keyboardWillHide(notification: NSNotification) {
		if (viewIsShifted) {
			self.view.frame.origin.y += getKeyboardHeight(notification)
			viewIsShifted = false
		}
	}

	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		return keyboardSize.CGRectValue().height
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.unsubscribeFromKeyboardNotifications()
	}

	@IBAction func pickImage(sender: UIBarButtonItem) {
		var ivc = UIImagePickerController()
		ivc.delegate = self
		presentViewController(ivc, animated: true, completion: nil)
	}

	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		img.image = image
		btnShare.enabled = true
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	func generateMemedImage() -> UIImage {
		navBar.hidden = true
		toolbar.hidden = true

		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
		let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		// show elements
		navBar.hidden = false
		toolbar.hidden = false

		return memedImage
	}
	func createMeme() -> Meme {
		return Meme(
			textTop: txtTop.text!,
			textBottom: txtBottom.text!,
			image: img.image,
			memedImage: generateMemedImage())
	}

	@IBAction func takePicture(sender: UIBarButtonItem) {
		var ivc = UIImagePickerController()
		ivc.delegate = self
		ivc.sourceType = UIImagePickerControllerSourceType.Camera
		presentViewController(ivc, animated: true, completion: nil)
	}

	@IBAction func shareMeme(sender: UIBarButtonItem) {
		createdMeme = createMeme()
		var avc = UIActivityViewController(activityItems: [createdMeme.memedImage], applicationActivities: nil)
		avc.completionWithItemsHandler = {activity, success, items, error in
			if !success {
				return
			}

			self.registerMeme()
			self.dismissViewControllerAnimated(true, completion: nil)
		}
		presentViewController(avc, animated: true, completion: nil)
	}

	func registerMeme() {
		let object = UIApplication.sharedApplication().delegate
		let appDelegate = object as! AppDelegate
		appDelegate.memes.append(createdMeme)
	}
	@IBAction func dismissView(sender: UIBarButtonItem) {
		dismissViewControllerAnimated(true, completion: nil)
	}

}

