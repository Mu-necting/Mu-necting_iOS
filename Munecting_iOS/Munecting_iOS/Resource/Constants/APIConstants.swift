import Foundation


struct APIConstants {
    
    // MARK: - base URL
    
    static let baseURL = "http://3.19.110.157:8080"
    
    //임시

    // MARK: - Users
    static let signUp = baseURL + "/join"
    
    static let login = baseURL + "/login"
    
    static let logout = baseURL + "/log-out"
    
    static let loginWithSocialURL = baseURL + "/oauth2/kakao"
    
    static let mailCheck = baseURL + "/mailCheck"
    
    static let issueTempPassword = baseURL + "/findpw"
    
    static let changeProfile = baseURL + "/members"
    
    static let getProfile = baseURL + "/members"
    
    static let changePassword = baseURL + "/members/changepw"
    
    static let deleteUser = baseURL + "/members/delete"

    
    // MARK: - Musics
    
    //업로드할 곡 검색(get)
    static let searchMusicURL = baseURL + "/musics"
    
    //음악 Upload(Post)
    static let uploadMusic = baseURL + "/musics"
    
    //주변 음악 검색(get)
    static let searchAroundMusicURL = baseURL + "/archive"
    
    //음악 Pick(Post)
    static let pickURL = baseURL + "/pick"
    
    //유튜브 전체 재생 링크(post)
    static let musicPullURL = baseURL + "/musics/youtube-fulllink"
    
    //reply 전송(post)
    static let sendReplyURL = baseURL + "/replies/reply"
    
    //reply 취소(post)
    static let cancelReplyURL = baseURL + "/replies/unreply"
    

    
    //MARK: - MunecingMap
    
    //MunectingMap 검색(get)
    static let searchMunectingMap = baseURL + "/archive/map"
    
    //MARK: - Munecting Rank
    
    //Munecting Rank 조회(get)
    static let searchMunectingRank = baseURL + "/members/rank"
    
 
    //MARK: - Archive
    
    //pick 상세조회 (get)
    static let pickDetailURL = baseURL + "/pick/{pickId}/detail"
}

