import Foundation
import UIKit

struct User : Codable {
    var userID : Int
    var userName: String = ""
    var profileImage: String?
    
    // 이미지를 서버에 저장하기 전에 넣어놓는 변수
    var prevSaveImage: UIImage?

    
    enum CodingKeys: String, CodingKey {
        case userID = "userIdx"
        case userName = "name"
        case profileImage = "profileImage"
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
    
    func setUserPrevSaveImage(image:UIImage){
        user?.prevSaveImage = image
    }
    
    func setUserName(name : String){
        user?.userName = name
    }
}
