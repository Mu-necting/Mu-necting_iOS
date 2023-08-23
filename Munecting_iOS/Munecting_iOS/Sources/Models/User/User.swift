import Foundation
import UIKit

struct User : Codable {
    var userID : Int
    var userName: String? = ""
    var profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userIdx"
        case userName = "name"
        case profileImage = "profileImage"
    }
    
    init(userID: Int, userName: String?, profileImage: String? = "") {
         self.userID = userID
         self.userName = userName
        
        if(profileImage == ""){
            self.profileImage = ""
        }else{
            self.profileImage = "https://munecting.s3.us-east-2.amazonaws.com/" + profileImage!
        }
     }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(Int.self, forKey: .userID)
        userName = try container.decodeIfPresent(String.self, forKey: .userName)

        if let image = try container.decodeIfPresent(String.self, forKey: .profileImage) {
            profileImage = "https://munecting.s3.us-east-2.amazonaws.com/" + image
        }
    }
}


class UserManager {
    static let shared = UserManager()
    
    private var user: User?
    
    // 이미지를 서버에 저장하기 전에 넣어놓는 변수
    private var prevSaveImage: UIImage?
    
    private init() {
        // Private initializer to prevent external instantiation
    }
    
    func setUser(_ newUser: User) {
        user = newUser
    }
    
    func getUser() -> User? {
        return user
    }
    
    func getPreSaveImage() -> UIImage?{
        return prevSaveImage
    }
    
    func setUserPrevSaveImage(image:UIImage){
        prevSaveImage = image
    }
    
    func setUserName(name : String){
        user?.userName = name
    }
}
