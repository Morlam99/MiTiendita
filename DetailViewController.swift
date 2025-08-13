//
//  DetailViewController.swift
//  CodePathCapstoneProject
//
//  Created by Morgan Martinez on 8/12/25.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

	var item: Item!
	private var imageData: Data?
	
	   var onSave: ((Item) -> Void)?

	   @IBOutlet weak var nameTextField: UITextField!
	   @IBOutlet weak var quantityTextField: UITextField!
	   @IBOutlet weak var itemImageView: UIImageView!

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[.originalImage] as? UIImage {
			itemImageView.image = image
			imageData = image.jpegData(compressionQuality: 0.8)
		}
		dismiss(animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}

	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= keyboardSize.height / 2
			}
		}
	}

	@objc func keyboardWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
		}
	}
	   override func viewDidLoad() {
		   super.viewDidLoad()
		   // Setup UI with item data
		   nameTextField.text = item.name
		   quantityTextField.text = "\(item.quantity)"
		   if let data = item.imageData {
			   itemImageView.image = UIImage(data: data)
		   } else {
			   itemImageView.image = UIImage(systemName: "photo")
		   }
		   nameTextField.delegate = self
			   quantityTextField.delegate = self
	   }
	//TO DELETE AN ITEM
	var onDelete: ((Item) -> Void)?

	@IBAction func deleteTapped(_ sender: UIButton) {
		var items = Item.getItems() // Load current items
		   if let index = items.firstIndex(where: { $0.id == item.id }) {
			   items.remove(at: index) // Remove the one we're editing
			   Item.save(items) // Save the updated list
		   }
		   navigationController?.popViewController(animated: true) // Go back
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder() // This dismisses the keyboard
		return true
	}
	   @IBAction func saveTapped(_ sender: UIButton) {
		   guard let name = nameTextField.text, !name.isEmpty,
				 let quantity = Int(quantityTextField.text ?? "") else {
			   // Show error or validation
			   return
		   }
		   item.name = name
		   item.quantity = quantity
		   onSave?(item)
		   navigationController?.popViewController(animated: true)
	   }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
