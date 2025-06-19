//
//  PopulationController.swift
//  project_ios
//
//  Created by An Pham Ngoc on 5/5/23.
//
import UIKit

protocol Copyable {
    init(instance: Self)
}
class SwiftPopulationModel: NSObject, Copyable {
    var population: Double?
    var id_year: Int?
    var year: String?
    var id_nation: String?
    var nation: String?
    var slug_nation: String?
    override init() {
    }
    func copy() -> SwiftPopulationModel {
        return SwiftPopulationModel(instance: self)
    }
    required init(instance: SwiftPopulationModel) {
        self.population = instance.population
        self.year = instance.year
        self.id_year = instance.id_year
        self.id_nation = instance.id_nation
        self.nation = instance.nation
        self.slug_nation = instance.slug_nation
    }
    func parseData (_ data: NSDictionary) -> SwiftPopulationModel {
        population = data.object(forKey: "Population") as? Double
        id_year = data.object(forKey: "ID Year") as? Int
        year = data.object(forKey: "Year") as? String
        id_nation = data.object(forKey: "ID Nation") as? String
        nation = data.object(forKey: "Nation") as? String
        slug_nation = data.object(forKey: "Slug Nation") as? String
        return self
    }
}
