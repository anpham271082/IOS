import UIKit
class SwiftPopulationViewModel{
	var reloadTableView: (()->())?
	var showError: (()->())?
	var showLoading: (()->())?
	var hideLoading: (()->())?
	private var cellViewModels: [SwiftPopulationModel] = [SwiftPopulationModel]() {
		didSet {
			self.reloadTableView?()
		}
	}
	func getData(){
		APIAlamofire.sharedInstance.receiveData(_url: "https://datausa.io/api/data?drilldowns=Nation&measures=Population", _method: Global.NETWORK_METHOD_GET) { result, code, message in
			let data_list = result?.object(forKey: "data") as! [AnyObject]
			for item in data_list {
				var populationModel = SwiftPopulationModel()
				populationModel = populationModel.parseData(item as! NSDictionary)
				self.cellViewModels.append(populationModel)
			}
			self.reloadTableView?()
		}
		/*showLoading?()
		ApiClient.getDataFromServer { (success, data) in
			self.hideLoading?()
			if success {
				self.createCell(datas: data!)
				self.reloadTableView?()
			} else {
				self.showError?()
			}
		}*/
	}
	func numberOfSections() -> Int {
		return 1
	}
	var numberOfRows: Int {
		return cellViewModels.count
	}
	func getCellViewModel( at indexPath: IndexPath ) -> SwiftPopulationModel {
		return cellViewModels[indexPath.row]
	}
}
