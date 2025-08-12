
import UIKit
protocol SwiftSettingCellDelegate: NSObjectProtocol {
    func actionSetting(_ swiftSettingCell: SwiftSettingCell)
}
class SwiftSettingCell: UITableViewCell {
    @IBOutlet weak var settingLabel: UILabel!
    weak var delegate: SwiftSettingCellDelegate?
    var index: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
    }
    func setSetting(_index: Int, text: String) {
        index = _index;
        settingLabel.text = text
    }
    @IBAction func actionSetting(_ sender: Any) {
        self.delegate?.actionSetting(self)
    }
}
