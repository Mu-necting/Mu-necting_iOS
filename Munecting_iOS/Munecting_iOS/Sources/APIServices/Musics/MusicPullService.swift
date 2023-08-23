import Alamofire
import Foundation

struct MusicPullService{
    static let shared = MusicPullService()
    struct EmptyResult: Codable {
        var url: String
    }
    
    
    func pullMusicURL(name: String, artist: String, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = "\(APIConstants.musicPullURL)?name=\(name)&artist=\(artist)"
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
//        print("=====PullMusicURL()In=======")
        let dataRequest = AF.request(url,
                                     method: .post,
                                     headers: header)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
//                print("======pullMusicURL의 NetworkReslt가 Success입니다==========")
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeMusicPull(status: statusCode, data: data))
            case .failure(let error):
//                print("======pullMusicURL의 NetworkReslt가 failure입니다==========")
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    func judgeMusicPull(status: Int, data: Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
//        print("====judgeMusicPull In=====")
        print(data)
        print(type(of: data))
//        guard let decodedData = try? decoder.decode(YouTubeVideo.self, from: data) else {return .pathErr}
        guard let decodedData = String(data: data, encoding: .utf8) else{return .pathErr}
//        print("======decode 성공=======")
        print(decodedData)
        switch status {
        case 200:
//            return .success(decodedData.result)
            return .success(decodedData)
        default:
            return .networkFail
        }
    }
    
    
}
