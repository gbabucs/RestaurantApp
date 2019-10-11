import Foundation

struct BaseModel : Codable {
	let meta : Meta?
	let response : Response?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
		case response = "response"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Meta.self, forKey: .meta)
		response = try values.decodeIfPresent(Response.self, forKey: .response)
	}

}
