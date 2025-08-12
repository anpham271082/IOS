import Foundation

enum APIRoute {
	case login(email: String, password: String)
	case getProfile(userID: String)
	case fetchPosts
	case updateProfile(userID: String, name: String)

	var path: String {
		switch self {
		case .login:
			return "/auth/login"
		case .getProfile(let userID):
			return "/users/\(userID)"
		case .fetchPosts:
			return "/posts"
		case .updateProfile(let userID, _):
			return "/users/\(userID)/update"
		}
	}

	var method: String {
		switch self {
		case .login, .updateProfile:
			return "POST"
		case .getProfile, .fetchPosts:
			return "GET"
		}
	}

	var headers: [String: String] {
		return [
			"Content-Type": "application/json",
			"Accept": "application/json"
			// Add auth token here if needed
		]
	}

	var body: Data? {
		switch self {
		case .login(let email, let password):
			let json = ["email": email, "password": password]
			return try? JSONSerialization.data(withJSONObject: json)
		case .updateProfile(_, let name):
			let json = ["name": name]
			return try? JSONSerialization.data(withJSONObject: json)
		default:
			return nil
		}
	}

	func asURLRequest(baseURL: URL) -> URLRequest {
		let url = baseURL.appendingPathComponent(path)
		var request = URLRequest(url: url)
		request.httpMethod = method
		request.allHTTPHeaderFields = headers
		request.httpBody = body
		return request
	}
}
