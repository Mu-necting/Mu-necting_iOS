import Alamofire
import Foundation

struct MusicUploadService{
    static let shared = MusicUploadService()
    struct EmptyResult: Codable {}
    
    func uploadMusic(name: String, coverImg: String, musicPre: String, musicPull: String, artist: String, genre: String, endTime: Int, pointX: Double, pointY: Double, memberID: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = APIConstants.pickURL
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
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeUploadMusic(status: statusCode, data: data))
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    func judgeUploadMusic(status: Int, data: Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<EmptyResult>.self, from: data) else {return .pathErr}
        
        switch status {
        case 1000:
            return .success(decodedData.result)
        default:
            return .networkFail
        }
    }
    
    
}
