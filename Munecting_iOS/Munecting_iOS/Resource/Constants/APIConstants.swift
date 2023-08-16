import Foundation


struct APIConstants {
    
    // MARK: - base URL
    
    static let baseURL = ""
    
    //임시

    // MARK: - Users
    static let loginWithSocialURL = baseURL + "/oauth2/kakao"
    
    // MARK: - Musics
    
    //업로드할 곡 검색(get)
    static let searchMusicURL = baseURL + "/musics"
    
    //주변 음악 검색(get)
    static let searchAroundMusicURL = baseURL + "/archive"
    
}

