import Foundation

struct GenericResponse<T: Codable>: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: T
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try values.decode(Bool.self, forKey: .isSuccess)
        code = try values.decode(Int.self, forKey: .code)
        message = try values.decode(String.self, forKey: .message)
        result = try values.decode(T.self, forKey: .result)
    }
}








/*
 struct GenericResponse<T: Codable>: Codable {
 var message: String
 var data: T?
 var error: String?
 
 enum CodingKeys: String, CodingKey {
 case message
 case data
 case error
 }
 
 init(from decoder: Decoder) throws {
 let values = try decoder.container(keyedBy: CodingKeys.self)
 message = (try? values.decode(String.self, forKey: .message)) ?? ""
 data = (try? values.decode(T.self, forKey: .data)) ?? nil
 error = (try? values.decode(String.self, forKey: .error)) ?? nil
 }
 }
 */
