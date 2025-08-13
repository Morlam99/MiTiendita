import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
	func didChangeSettings(settings: [String: Any])
}

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	weak var delegate: SettingsViewControllerDelegate?
	
	private let imagePicker = UIImagePickerController()
	private var currentImageData: Data?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imagePicker.delegate = self
	}
	
	@IBAction func didTapChangeProfilePic(_ sender: Any) {
		imagePicker.sourceType = .photoLibrary
		imagePicker.allowsEditing = true
		present(imagePicker, animated: true)
	}
	
	@IBAction func didTapChangeGreetingLabel(_ sender: Any) {
		let alert = UIAlertController(title: "Change Business Name", message: "Enter new business name", preferredStyle: .alert)
		
		alert.addTextField { [weak self] textField in
			textField.placeholder = "Business name"
			if let currentName = UserDefaults.standard.string(forKey: "businessName") {
				textField.text = currentName
			}
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak alert] _ in
			guard let newName = alert?.textFields?.first?.text, !newName.isEmpty else { return }
			UserDefaults.standard.set(newName, forKey: "businessName")
			
			// Notify delegate about the change
			self?.delegate?.didChangeSettings(settings: ["businessName": newName])
		}))
		
		present(alert, animated: true)
	}
	
	// MARK: - UIImagePickerControllerDelegate
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		var selectedImage: UIImage?
				if let editedImage = info[.editedImage] as? UIImage {
			selectedImage = editedImage
		} else if let originalImage = info[.originalImage] as? UIImage {
			selectedImage = originalImage
		}
		
		if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
			currentImageData = imageData
			UserDefaults.standard.set(imageData, forKey: "businessImageData")
			
			// Notify delegate about the change
			self.delegate?.didChangeSettings(settings: ["businessImageData": imageData])
		}
		
		dismiss(animated: true)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true)
	}
}
