//
//  PopulationController.swift
//  project_ios
//
//  Created by An Pham Ngoc on 5/5/23.
//

import Foundation
import UIKit
class SwiftSettingController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var array: NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        array.add("Login FaceBook")
        array.add("Login Twitter")
        array.add("Share AppTo Facebook")
        array.add("Share AppTo Twitter")
        self.tableView.reloadData()
		Tutorial3.test()
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
extension SwiftSettingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftSettingCell") as! SwiftSettingCell
        cell.delegate = self;
        cell.setSetting(_index: indexPath.item, text: array[indexPath.item] as! String)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension SwiftSettingController: SwiftSettingCellDelegate {
    func actionSetting(_ swiftSettingCell: SwiftSettingCell){
        switch(swiftSettingCell.index){
            case 0:
                UtilsSocial.loginFacebook(self)
                break
            case 1:
                UtilsSocial.loginTwitter(self)
                break
            case 2:
                UtilsSocial.shareAppToFacebook(self)
                break
            case 3:
                UtilsSocial.shareAppToTwitter(self)
                break
            default:
                break
        }
    }
}
