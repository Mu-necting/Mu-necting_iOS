import Foundation

struct SimpleResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
}
