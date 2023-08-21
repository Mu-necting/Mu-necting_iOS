import Foundation

struct Tokens: Codable{
    var tokens: [Token]
}

struct Token: Codable{
    var types : String
    var token : String
    var tokenExpiresTime : String
}



