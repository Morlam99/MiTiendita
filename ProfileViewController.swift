//
//  ProfileViewController.swift
//  CodePathCapstoneProject
//
//  Created by Morgan Martinez on 8/10/25.
//

import UIKit

class ProfileViewController: UIViewController, SettingsViewControllerDelegate {
	@IBOutlet weak var greetingLabel: UILabel!
	@IBOutlet weak var profilePicImageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		updateUIFromUserDefaults()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateUIFromUserDefaults()
	}
	
	private func updateUIFromUserDefaults() {
		if let savedName = UserDefaults.standard.string(forKey: "businessName") {
			greetingLabel.text = "Hello, \(savedName)"
		} else {
			greetingLabel.text = "Hello"
		}
		if let imageData = UserDefaults.standard.data(forKey: "businessImageData"),
		   let image = UIImage(data: imageData) {
			profilePicImageView.image = image
		} else {
			profilePicImageView.image = nil // or a placeholder
		}
	}
	
	@IBAction func didTapSettingsButton(_ sender: Any) {
		performSegue(withIdentifier: "SettingsViewControllerSegue", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SettingsViewControllerSegue",
		   let settingsVC = segue.destination as? SettingsViewController {
			settingsVC.delegate = self
		}
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2
		profilePicImageView.clipsToBounds = true
	}
	// MARK: - SettingsViewControllerDelegate
	
	
	
	func didChangeSettings(settings: [String: Any]) {
		// Update UI immediately based on what changed
		if let newName = settings["businessName"] as? String {
			greetingLabel.text = "Hello, \(newName)"
		}
		if let imageData = settings["businessImageData"] as? Data,
		   let image = UIImage(data: imageData) {
			profilePicImageView.image = image
		}
	}
}
