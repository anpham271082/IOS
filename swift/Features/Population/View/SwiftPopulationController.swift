//
//  PopulationController.swift
//  project_ios
//
//  Created by An Pham Ngoc on 5/5/23.
//

import Foundation
import UIKit
class SwiftPopulationController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
	var dataViewModel = SwiftPopulationViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
		initViewModel()
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
extension SwiftPopulationController: UITableViewDelegate, UITableViewDataSource {
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
}
extension SwiftPopulationController: SwiftPopulationCellDelegate {
    func actionPopulation(_ swiftPopulationCell: SwiftPopulationCell){
		UtilsLogger.log(swiftPopulationCell.populationModel)
    }
}
