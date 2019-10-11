import Foundation

struct Stats : Codable {
	let tipCount : Int?
	let usersCount : Int?
	let checkinsCount : Int?
	let visitsCount : Int?

	enum CodingKeys: String, CodingKey {

		case tipCount = "tipCount"
		case usersCount = "usersCount"
		case checkinsCount = "checkinsCount"
		case visitsCount = "visitsCount"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		tipCount = try values.decodeIfPresent(Int.self, forKey: .tipCount)
		usersCount = try values.decodeIfPresent(Int.self, forKey: .usersCount)
		checkinsCount = try values.decodeIfPresent(Int.self, forKey: .checkinsCount)
		visitsCount = try values.decodeIfPresent(Int.self, forKey: .visitsCount)
	}

}
