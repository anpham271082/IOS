//
//  Global.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/13/24.
//

import Foundation

enum Environment {
	case development
	case staging
	case production
}

final class AppConfig {
	static let shared = AppConfig()

	let environment: Environment
	let apiBaseURL: String
	let enableLogging: Bool
	let appVersion: String

	private init() {
#if DEBUG
		self.environment = .development
#elseif STAGING
		self.environment = .staging
#else
		self.environment = .production
#endif
		switch environment {
		case .development:
			self.apiBaseURL = "https://dev.api.example.com"
			self.enableLogging = true
		case .staging:
			self.apiBaseURL = "https://staging.api.example.com"
			self.enableLogging = true
		case .production:
			self.apiBaseURL = "https://api.example.com"
			self.enableLogging = false
		}

		self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
	}
}
