//
//  SwiftUserModel.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/17/25.
//

import Foundation

struct SwiftUserModel {
	let name: String
	let avatarSystemName: String

	static func mockList() -> [SwiftUserModel] {
		return [
			SwiftUserModel(name: "Alice Johnson", avatarSystemName: "person.circle.fill"),
			SwiftUserModel(name: "Bob Smith", avatarSystemName: "person.crop.circle.fill"),
			SwiftUserModel(name: "Charlie Lee", avatarSystemName: "person.2.circle.fill"),
			SwiftUserModel(name: "Dana Wu", avatarSystemName: "person.3.fill"),
			SwiftUserModel(name: "Eve Turner", avatarSystemName: "person.fill.badge.plus")
		]
	}
}
