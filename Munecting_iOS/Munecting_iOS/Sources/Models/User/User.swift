import Foundation

struct User : Codable {
    var userID : Int
    var userName: String?
    var profileImage: String?

    
    enum CodingKeys: String, CodingKey {
        case userID
        case userName
        case profileImage = "profile_img"
    }
}


class UserManager {
    static let shared = UserManager()
    
    private var user: User?
    
    private init() {
        // Private initializer to prevent external instantiation
    }
    
    func setUser(_ newUser: User) {
        user = newUser
    }
    
    func getUser() -> User? {
        return user
    }
}
