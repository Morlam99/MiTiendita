//
//  AddItemViewController.swift
//  CodePathCapstoneProject
//
//  Created by Morgan Martinez on 8/12/25.
//

import UIKit

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	var onSave: ((Item) -> Void)?
	
	@IBOutlet weak var emptyLabel: UILabel!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var quantityTextField: UITextField!
	@IBOutlet weak var itemImageView: UIImageView!
	
	@IBOutlet weak var addItemImageButton: UIButton!
	private var imageData: Data?

	@IBAction func selectImageTapped(_ sender: UIButton) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = .photoLibrary
		present(picker, animated: true)
		if let image = itemImageView.image {
			   emptyLabel.isHidden = !image.isHighDynamicRange
		   } else {
			   emptyLabel.isHidden = true
		   }
		   addItemImageButton.isHidden = emptyLabel.isHidden
	}

	

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[.originalImage] as? UIImage {
			itemImageView.image = image
			imageData = image.jpegData(compressionQuality: 0.8)
		}
		
		dismiss(animated: true)
	}
	
	@IBAction func saveTapped(_ sender: UIButton) {
		guard let name = nameTextField.text, !name.isEmpty,
			  let qtyText = quantityTextField.text, let qty = Int(qtyText) else {
			return
		}
		
		let newItem = Item(name: name, quantity: qty, imageData: imageData)
		print("Save tapped, creating new item: \(newItem.name), qty: \(newItem.quantity)")
		onSave?(newItem)
		dismiss(animated: true)
	}
	
	@IBAction func cancelTapped(_ sender: UIButton) {
		dismiss(animated: true)
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		nameTextField.delegate = self
		quantityTextField.delegate = self
		print("AddItemViewController loaded; onSave is \(onSave != nil ? "set" : "nil")")
	}
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


