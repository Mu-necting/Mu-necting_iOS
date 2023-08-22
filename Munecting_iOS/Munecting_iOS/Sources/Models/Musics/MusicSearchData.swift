import Foundation
import UIKit


struct MusicSearchResult: Codable {
    var musicSearchRes: [MusicItem]
    var totalPage: Int
}

struct MusicItem: Codable {
    var name: String
    var artist: String
    var coverImg: String
    var musicPre: String?
}




