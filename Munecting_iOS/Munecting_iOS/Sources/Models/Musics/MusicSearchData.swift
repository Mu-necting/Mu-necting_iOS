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
    var musicPre: String
}


/*
 "isSuccess": true,
 "code": 1000,
 "message": "요청에 성공하였습니다.",
 "result": {
     "musicSearchRes": [
         {
             "name": "Barbie World (with Aqua) [From Barbie The Album]",
             "artist": "Nicki Minaj",
             "coverImg": "https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116"
         },
 */
