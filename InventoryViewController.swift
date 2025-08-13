import UIKit
class InventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var items: [Item] = []
	
	@IBOutlet weak var inventoryTableView: UITableView!
	
	@IBAction func didTapAddButton(_ sender: Any) {
		print("Add button tapped")  // <- This should print in console
		performSegue(withIdentifier: "showAddItem", sender: nil)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("Preparing for segue: \(segue.identifier ?? "nil")")
		if segue.identifier == "showDetail" {
			if let detailVC = segue.destination as? DetailViewController,
			   let indexPath = inventoryTableView.indexPathForSelectedRow {
				
				let selectedItem = items[indexPath.row]
				detailVC.item = selectedItem
				
				detailVC.onSave = { [weak self] updatedItem in
					guard let self = self else { return }
					if let index = self.items.firstIndex(where: { $0.id == updatedItem.id }) {
						self.items[index] = updatedItem
						Item.save(self.items)
						self.inventoryTableView.reloadData()
					}
				}
				
				detailVC.onDelete = { [weak self] itemToDelete in
					guard let self = self else { return }
					if let index = self.items.firstIndex(where: { $0.id == itemToDelete.id }) {
						self.items.remove(at: index)
						Item.save(self.items)
						self.inventoryTableView.reloadData()
					}
				}
			}
		}
		else if segue.identifier == "showAddItem" {
			if let nav = segue.destination as? UINavigationController,
			   let addItemVC = nav.topViewController as? AddItemViewController {
				print("Assigning onSave closure")
				addItemVC.onSave = { [weak self] newItem in
					guard let self = self else { return }
					self.items.append(newItem)
					Item.save(self.items)
					self.inventoryTableView.reloadData()
				}
			}
		}
	}



	override func viewDidLoad() {
		super.viewDidLoad()
		
		inventoryTableView.dataSource = self
		inventoryTableView.delegate = self
		
		// Load items from UserDefaults
		items = Item.getItems()
		
		// If you’re not using a prototype cell from storyboard, register the nib or class
		// inventoryTableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
		
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		   items = Item.getItems()
		inventoryTableView.reloadData()
	}
	// MARK: - Table View Data Source
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
			   fatalError("Could not dequeue ItemCell")
		   }
		   
		   let item = items[indexPath.row]
		cell.configure(with: item) { updatedItem in
			self.items[indexPath.row] = updatedItem
			Item.save(self.items)
			tableView.reloadRows(at: [indexPath], with: .automatic)
		   }
		   
		   return cell
	}
}
