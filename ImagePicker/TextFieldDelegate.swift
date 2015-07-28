//
//  TextFieldDelegate
//  ImagePicker
//
//  Created by Dany Cabrera Vargas on 27/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import UIKit

// TextField delegate
class TextFieldDelegate: NSObject, UITextFieldDelegate {
	var defaultText: String!

	init(defText: String!) {
		defaultText = defText
	}

	// on begin editing, clear text if defaultText
	func textFieldDidBeginEditing(textField: UITextField) {
		if (textField.text == defaultText) {
			textField.text = ""
		}
	}

	// on finish editing, fill default text if empty
	func textFieldDidEndEditing(textField: UITextField) {
		if (textField.text == "") {
			textField.text = defaultText
		}
	}

	// handle return key; hide keyboard
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if (textField.text == "") {
			textField.text = defaultText
		}
		textField.resignFirstResponder()
		return true
	}

	// uppercase on text editing
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		var newText = textField.text as NSString
		newText = newText.stringByReplacingCharactersInRange(range, withString: string)
		textField.text = newText.uppercaseString

		return false
	}
}