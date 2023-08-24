import Alamofire
import Foundation

struct MusicUploadService{
    static let shared = MusicUploadService()
    struct EmptyResult: Codable {}
    
    func uploadMusic(name: String, coverImg: String, musicPre: String, musicPull: String, artist: String, genre: String, endTime: Int, pointX: Double, pointY: Double, memberID: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        
        print("======uploadMusic In==========")

        let url = APIConstants.uploadMusic
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = [
            "name": name,
            "coverImg": coverImg,
            "musicPre": musicPre,
            "musicPull": musicPull,
            "artist": artist,
            "genre": genre,
            "endTime": endTime,
            "pointX": pointX,
            "pointY": pointY,
            "memberID": memberID
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: URLEncoding.default,
                                     headers: header)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                print("======response.result == success ==========")
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeUploadMusic(status: statusCode, data: data))
            case .failure(let error):
                print("======response.result == failure ==========")
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    func judgeUploadMusic(status: Int, data: Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        print("======judgeUplocaMuisc in=========")
        return .success(data)

//        guard let decodedData = try? decoder.decode(SimpleResponse.self, from: data) else {return .pathErr}
//        print("======decode 성공=========")
//        switch decodedData.code {
//        case 1000:
//            return .success(data)
//        default:
//            return .networkFail
//        }
    }
    
    
}
