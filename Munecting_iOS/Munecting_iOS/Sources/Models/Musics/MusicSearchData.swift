import Foundation
import UIKit

struct MusicSearchData: Codable{
    var searchMusic: [SearchMusic]
}

struct SearchMusic: Codable{
    let name: String
    let artist: String
    let coverImg: String
}
