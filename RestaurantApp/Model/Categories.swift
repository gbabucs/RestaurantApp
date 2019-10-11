import Foundation

struct Categories : Codable {
	let id : String?
	let name : String?
	let pluralName : String?
	let shortName : String?
	let primary : Bool?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case pluralName = "pluralName"
		case shortName = "shortName"
		case primary = "primary"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		pluralName = try values.decodeIfPresent(String.self, forKey: .pluralName)
		shortName = try values.decodeIfPresent(String.self, forKey: .shortName)
		primary = try values.decodeIfPresent(Bool.self, forKey: .primary)
	}

}
