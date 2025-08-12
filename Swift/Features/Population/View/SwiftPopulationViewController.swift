//
//  PopulationController.swift
//  project_ios
//
//  Created by An Pham Ngoc on 5/5/23.
//

import Foundation
import UIKit
enum RefreshState {
	case idle
	case readyToRelease
	case loading
}
class SwiftPopulationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
	
	let refreshControl = UIRefreshControl()
	let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.down"))
	let activityIndicator = UIActivityIndicatorView(style: .medium)
	let statusLabel = UILabel()

	var shouldRefresh = false
	
	var dataViewModel = SwiftPopulationViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
		setupCustomRefresh()
		initViewModel()
    }
	func setupCustomRefresh() {
		refreshControl.tintColor = .clear

		arrowImageView.tintColor = .systemGray
		arrowImageView.contentMode = .scaleAspectFit
		arrowImageView.frame = CGRect(x: (view.frame.width - 100)/2 - 30, y: 10, width: 20, height: 20)

		activityIndicator.frame = arrowImageView.frame
		activityIndicator.hidesWhenStopped = true

		statusLabel.text = "Pull to refresh"
		statusLabel.font = .systemFont(ofSize: 14)
		statusLabel.textAlignment = .center
		statusLabel.frame = CGRect(x: (view.frame.width - 200)/2 + 10, y: 10, width: 150, height: 20)

		refreshControl.addSubview(arrowImageView)
		refreshControl.addSubview(activityIndicator)
		refreshControl.addSubview(statusLabel)

		tableView.refreshControl = refreshControl
	}
	func triggerRefresh() {
		updateRefreshUI(state: .loading)
		refreshControl.beginRefreshing()

		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			self.tableView.reloadData()
			self.refreshControl.endRefreshing()
			self.updateRefreshUI(state: .idle)
		}
	}

	func updateRefreshUI(state: RefreshState) {
		switch state {
		case .idle:
			arrowImageView.isHidden = false
			activityIndicator.stopAnimating()
			statusLabel.text = "Pull to refresh"
			UIView.animate(withDuration: 0.2) {
				self.arrowImageView.transform = .identity
			}
		case .readyToRelease:
			statusLabel.text = "Release to refresh"
			UIView.animate(withDuration: 0.2) {
				self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
			}
		case .loading:
			arrowImageView.isHidden = true
			activityIndicator.startAnimating()
			statusLabel.text = "Refreshing..."
		}
	}
	
	func initViewModel(){
		dataViewModel.reloadTableView = {
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
		dataViewModel.showError = {
			//DispatchQueue.main.async { self.showAlert("Ups, something went wrong.") }
		}
		dataViewModel.showLoading = {
			//DispatchQueue.main.async { self.activityIndicator.startAnimating() }
		}
		dataViewModel.hideLoading = {
			//DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
		}
		dataViewModel.getData()
	}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewDidLayoutSubviews() {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SwiftPopulationViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftPopulationCell") as! SwiftPopulationCell
        cell.delegate = self;
        cell.setPopulation(_index: indexPath.item, _populationModel:dataViewModel.getCellViewModel(at: indexPath ))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataViewModel.numberOfRows
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
	
	func tableView(_ tableView: UITableView,
				   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
	) -> UISwipeActionsConfiguration? {
		
		// Action delete
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
			guard let self = self else { return }

			let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
				completionHandler(false)
			}))
			alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
				self.dataViewModel.deleteItem(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .left)
				completionHandler(true)
			}))
			self.present(alert, animated: true, completion: nil)
		}
		deleteAction.backgroundColor = .systemRed
		deleteAction.image = UIImage(systemName: "trash")

		// Action edit
		let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
			print("Edit row \(indexPath.row)")
			completionHandler(true)
		}
		editAction.backgroundColor = .systemOrange
		editAction.image = UIImage(systemName: "pencil")

		let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
		config.performsFirstActionWithFullSwipe = false 
		return config
	}
	
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard !refreshControl.isRefreshing else { return }

		let offsetY = scrollView.contentOffset.y

		if offsetY < -100 {
			shouldRefresh = true
			updateRefreshUI(state: .readyToRelease)
		} else {
			shouldRefresh = false
			updateRefreshUI(state: .idle)
		}
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if shouldRefresh {
			triggerRefresh()
		}
	}
}
extension SwiftPopulationViewController: SwiftPopulationCellDelegate {
    func actionPopulation(_ swiftPopulationCell: SwiftPopulationCell){
		UtilsLogger.log(swiftPopulationCell.populationModel)
    }
}
