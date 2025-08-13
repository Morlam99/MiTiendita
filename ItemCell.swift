import UIKit

class ItemCell: UITableViewCell {
	
	@IBOutlet weak var itemNameTextField: UITextField!
	@IBOutlet weak var quantityLabel: UILabel!
	@IBOutlet weak var itemImageView: UIImageView!
	@IBOutlet weak var soldButton: UIButton!

	private var item: Item!
	var onSoldButtonTapped: ((Item) -> Void)?
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func configure(with item: Item, onSoldButtonTapped: ((Item) -> Void)?) {
		self.item = item
		self.onSoldButtonTapped = onSoldButtonTapped
		updateUI()
	}

	private func updateUI() {
		itemNameTextField.text = item.name
		quantityLabel.text = "Qty: \(item.quantity)"
		quantityLabel.backgroundColor = .systemBackground
		if let data = item.imageData {
			itemImageView.image = UIImage(data: data)
		} else {
			itemImageView.image = UIImage(systemName: "photo")
		}
	}


	@IBAction func didTapSoldButton(_ sender: UIButton) {
		guard let item = item, item.quantity > 0 else { return }
		   
		   var updatedItem = item
		   updatedItem.quantity -= 1
		   updatedItem.isSold = true
		   
		   onSoldButtonTapped?(updatedItem)
	}
}
