import Foundation

enum Genre: Int, Codable, CaseIterable {
    case hiphop
    case rock
    case balad
    case classic
    case pop
    case blues
    case rnb
    case country
    case edm
    case kpop
    
    enum CodingKeys: String, CodingKey {
        case hiphop = "hiphop"
        case rock
        case balad
        case classic
        case pop
        case blues
        case rnb
        case country
        case edm
        case kpop
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let genreString = try container.decode(String.self)
        
        switch genreString {
        case "hiphop":
            self = .hiphop
        case "rock":
            self = .rock
        case "balad":
            self = .balad
        case "classic":
            self = .classic
        case "pop":
            self = .pop
        case "blues":
            self = .blues
        case "rnb":
            self = .rnb
        case "country":
            self = .country
        case "edm":
            self = .edm
        case "kpop":
            self = .kpop
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown genre: \(genreString)"
            )
        }
    }
}
