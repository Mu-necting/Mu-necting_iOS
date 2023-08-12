import Foundation
import UIKit

struct MusicSearchAround: Codable{
    var AroundMusics: [AroundMusic]
}

struct AroundMusic: Codable{
    let name: String
    let coverImage: String
    let genre: String
    let musicPre: String
    let musicPull: String
    let replyCnt: Int
    let archiveId: Int
}



