import Foundation


struct APIConstants {
    
    // MARK: - base URL
    
    static let baseURL = ""
    
    //임시

    // MARK: - Users
    static let signUp = baseURL + "/join"
    
    static let login = baseURL + "/login"
    
    static let loginWithSocialURL = baseURL + "/oauth2/kakao"
    
    static let mailCheck = baseURL + "/mailCheck"
    
    static let issueTempPassword = baseURL + "/findpw"
    
    // MARK: - Musics
    
    //업로드할 곡 검색(get)
    static let searchMusicURL = baseURL + "/musics"
    
    //주변 음악 검색(get)
    static let searchAroundMusicURL = baseURL + "/archive"
    
}

