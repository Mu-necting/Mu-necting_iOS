import Foundation

enum Genre: Int, Codable, CaseIterable {
    case hiphop
    case balad
    case kpop
    
    enum CodingKeys: String, CodingKey {
        case hiphop = "hiphop"
        case balad
        case kpop
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let genreString = try container.decode(String.self)
        
        switch genreString {
        case "hiphop":
            self = .hiphop
        case "balad":
            self = .balad
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
