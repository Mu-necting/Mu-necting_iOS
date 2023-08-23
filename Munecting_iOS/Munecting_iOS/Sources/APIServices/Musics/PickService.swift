import Alamofire
import Foundation

struct PickService{
    static let shared = PickService()
    struct EmptyResult: Codable {}
    
    func PickMusic(writing: String, memberId: Int, archievId: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = APIConstants.pickURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = [
            "writing" : writing,
            "memberId" : memberId,
            "archievId" : archievId
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
                completion(judgePickMusic(status: statusCode, data: data))
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    func judgePickMusic(status: Int, data: Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SimpleResponse.self, from: data) else {return .pathErr}
        
        switch decodedData.code {
        case 1000:
            return .success(decodedData)
        default:
            return .networkFail
        }
    }
    
    
}
