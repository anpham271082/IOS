
import UIKit
protocol SwiftPopulationCellDelegate: NSObjectProtocol {
    func actionPopulation(_ swiftPopulationCell: SwiftPopulationCell)
}
class SwiftPopulationCell: UITableViewCell {
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var id_yearLabel: UILabel!
    @IBOutlet weak var id_nationLabel: UILabel!
    @IBOutlet weak var nationLabel: UILabel!
    @IBOutlet weak var slug_nationLabel: UILabel!
    weak var delegate: SwiftPopulationCellDelegate?
    var index: Int = 0
    var populationModel: SwiftPopulationModel = SwiftPopulationModel()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
    }
    func setPopulation(_index: Int, _populationModel: SwiftPopulationModel) {
        index = _index;
        populationLabel.text = String(_populationModel.population!)
        yearLabel.text = String(_populationModel.year!)
        id_yearLabel.text = String(_populationModel.id_year!)
        id_nationLabel.text = String(_populationModel.id_nation!)
        nationLabel.text = String(_populationModel.nation!)
        slug_nationLabel.text = String(_populationModel.slug_nation!)
        populationModel = _populationModel
    }
    @IBAction func actionPopulation(_ sender: Any) {
        self.delegate?.actionPopulation(self)
    }
}
