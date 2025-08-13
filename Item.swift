import UIKit

struct Item: Codable, Equatable {
	var id: String = UUID().uuidString
	var name: String
	var quantity: Int
	//var price: Int
	var imageData: Data? // Store as Data, convert to UIImage when displaying
	
	var isSold: Bool = false 
	
	// MARK: - Persistence
	private static var key = "items"

	static func save(_ items: [Item]) {
		if let encoded = try? JSONEncoder().encode(items) {
			UserDefaults.standard.set(encoded, forKey: key)
		}
	}

	static func getItems() -> [Item] {
		guard let data = UserDefaults.standard.data(forKey: key),
			  let decoded = try? JSONDecoder().decode([Item].self, from: data) else {
			return []
		}
		return decoded
	}

	func save() {
		var saved = Item.getItems()
		if let idx = saved.firstIndex(where: { $0.id == id }) {
			saved[idx] = self
		} else {
			saved.append(self)
		}
		Item.save(saved)
	}
}
