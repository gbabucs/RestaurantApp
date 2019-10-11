import Foundation

struct Coordinate {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "\(latitude),\(longitude)"
    }
}

extension Coordinate: Equatable {
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
}


struct Location : Codable {
	let address : String?
	let crossStreet : String?
	let lat : Double?
	let lng : Double?
    let coordinate: Coordinate?
	let distance : Int?
	let postalCode : String?
	let cc : String?
	let neighborhood : String?
	let city : String?
	let state : String?
	let country : String?
	let formattedAddress : [String]?

	enum CodingKeys: String, CodingKey {

		case address = "address"
		case crossStreet = "crossStreet"
		case lat = "lat"
		case lng = "lng"
		case distance = "distance"
		case postalCode = "postalCode"
		case cc = "cc"
		case neighborhood = "neighborhood"
		case city = "city"
		case state = "state"
		case country = "country"
		case formattedAddress = "formattedAddress"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		crossStreet = try values.decodeIfPresent(String.self, forKey: .crossStreet)
		lat = try values.decodeIfPresent(Double.self, forKey: .lat)
		lng = try values.decodeIfPresent(Double.self, forKey: .lng)
		distance = try values.decodeIfPresent(Int.self, forKey: .distance)
		postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
		cc = try values.decodeIfPresent(String.self, forKey: .cc)
		neighborhood = try values.decodeIfPresent(String.self, forKey: .neighborhood)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		formattedAddress = try values.decodeIfPresent([String].self, forKey: .formattedAddress)
        
        if let latitude = lat, let longitude = lng {
            coordinate = Coordinate(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
	}

}
