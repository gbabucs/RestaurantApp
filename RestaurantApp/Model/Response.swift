import Foundation

struct Response : Codable {
	let venues : [Venues]?
	let confident : Bool?

	enum CodingKeys: String, CodingKey {

		case venues = "venues"
		case confident = "confident"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		venues = try values.decodeIfPresent([Venues].self, forKey: .venues)
		confident = try values.decodeIfPresent(Bool.self, forKey: .confident)
	}

}
