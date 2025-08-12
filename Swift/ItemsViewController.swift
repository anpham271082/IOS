//
//  ItemsTableViewController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/11/25.
//

import UIKit

class ItemsViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	private var data: [(UIImage?, String, String, String)] = [
		(UIImage(named: "Frankfurt"), "Aurora Lights", "Beautiful northern lights scenery", "NEW"),
		(UIImage(named: "Hamburg"), "Ocean Sunset", "Golden rays reflecting on water", "HOT"),
		(UIImage(named: "JoshuaTree"), "Mountain Peaks", "Snowy mountains in the morning", "TOP"),
		(UIImage(named: "LonsdaleQuay"), "Desert Dunes", "Golden sands under clear sky", "NEW"),
		(UIImage(named: "NobleRidge"), "City Lights", "Skyscrapers shining at night", "TOP")
	]

	/// Lưu các indexPath của các cell đang mở swipe
	private var openIndexPaths = Set<IndexPath>()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Items"
		view.backgroundColor = UIColor.systemGray6
		tableView.register(ItemsTableViewCell.self, forCellReuseIdentifier: ItemsTableViewCell.identifier)
		tableView.separatorStyle = .none
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 200

		tableView.dragInteractionEnabled = true
		tableView.dragDelegate = self
		tableView.dropDelegate = self
	}
}
extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ItemsTableViewCell.identifier, for: indexPath) as! ItemsTableViewCell
		let item = data[indexPath.row]
		cell.configure(image: item.0, title: item.1, subtitle: item.2, badge: item.3)
		cell.delegate = self
		
		// Đồng bộ trạng thái mở/đóng khi cell reuse
		if openIndexPaths.contains(indexPath) {
			cell.openActions(animated: false)
		} else {
			cell.closeActions(animated: false)
		}
		
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
}
extension ItemsViewController: ItemsTableViewCellDelegate {
	// MARK: - ItemsTableViewCellDelegate
	func itemsTableViewCellDidTapEdit(_ cell: ItemsTableViewCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		print("Edit tapped at index: \(indexPath.row)")
		openIndexPaths.remove(indexPath)
		cell.closeActions(animated: true)
		let item = data[indexPath.row]
		let alert = UIAlertController(title: "Edit", message: "Edit \(item.1) at row \(indexPath.row)", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}

	func itemsTableViewCellDidTapDelete(_ cell: ItemsTableViewCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { return }
		print("Delete tapped at index: \(indexPath.row)")
		openIndexPaths.remove(indexPath)
		data.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}

	// Khi cell mở swipe, delegate gọi hàm này để cập nhật trạng thái mở
	func cellDidOpen(_ cell: ItemsTableViewCell) {
		if let indexPath = tableView.indexPath(for: cell) {
			openIndexPaths.insert(indexPath)
			// Đóng các cell khác đang mở
			closeOtherCells(except: indexPath)
		}
	}

	private func closeOtherCells(except indexPath: IndexPath) {
		for ip in openIndexPaths where ip != indexPath {
			if let cell = tableView.cellForRow(at: ip) as? ItemsTableViewCell {
				cell.closeActions(animated: true)
			}
		}
		openIndexPaths = [indexPath]
	}

	// Tự động đóng tất cả cell đang mở khi bắt đầu scroll
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		for indexPath in openIndexPaths {
			if let cell = tableView.cellForRow(at: indexPath) as? ItemsTableViewCell {
				cell.closeActions(animated: true)
			}
		}
		openIndexPaths.removeAll()
	}
}
// MARK: - Drag & Drop Delegate
extension ItemsViewController: UITableViewDragDelegate, UITableViewDropDelegate {
	func tableView(_ tableView: UITableView,
				   itemsForBeginning session: UIDragSession,
				   at indexPath: IndexPath) -> [UIDragItem] {
		let item = data[indexPath.row].1 as NSString
		let itemProvider = NSItemProvider(object: item)
		let dragItem = UIDragItem(itemProvider: itemProvider)
		dragItem.localObject = data[indexPath.row]
		return [dragItem]
	}

	func tableView(_ tableView: UITableView,
				   performDropWith coordinator: UITableViewDropCoordinator) {
		guard coordinator.proposal.operation == .move,
			  let item = coordinator.items.first,
			  let sourceIndexPath = item.sourceIndexPath else { return }

		var destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: data.count - 1, section: 0)

		if destinationIndexPath.row >= data.count {
			destinationIndexPath.row = data.count - 1
		}

		tableView.performBatchUpdates {
			let movedObject = data.remove(at: sourceIndexPath.row)
			data.insert(movedObject, at: destinationIndexPath.row)
			tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
		}
	}

	func tableView(_ tableView: UITableView,
				   dropSessionDidUpdate session: UIDropSession,
				   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
		return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
	}
}
