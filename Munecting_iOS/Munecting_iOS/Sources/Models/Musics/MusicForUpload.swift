import Foundation

struct MusicForUpload: Codable{
    var name: String
    var coverImg: String
    var musicPre: String
    var musicPull: String?
    var artist: String
    var genre: String?
    var endTime: Int?
    var pointX: Double?
    var pointY: Double?
    var memberID: Int?
}
