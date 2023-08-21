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
    
    static let changeProfile = baseURL + "/members"
    
    static let getProfile = baseURL + "/members"
    
    // MARK: - Musics
    
    //업로드할 곡 검색(get)
    static let searchMusicURL = baseURL + "/musics"
    
    //음악 Upload(Post)
    static let uploadMusic = baseURL + "/musics"
    
    //주변 음악 검색(get)
    static let searchAroundMusicURL = baseURL + "/archive"
    
    //음악 Pick(Post)
    static let pickURL = baseURL + "/pick"
    

    
    //MARK: - MunecingMap
    
    //MunectingMap 검색(get)
    static let searchMunectingMap = baseURL + "/map"
    
    //MARK: - Munecting Rank
    
    //Munecting Rank 조회(get)
    static let searchMunectingRank = baseURL + "/rank"
    
    
}

