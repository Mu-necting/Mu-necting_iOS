import Alamofire
import Foundation

struct MunectingRankService{
    static let shared = MunectingRankService()
    
    
    func searchMunectingRank(rank: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = APIConstants.searchMunectingRank
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = [
            "rank" : rank
        ]
        
        let dataRequest = AF.request(url,
                                     method: .get,
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
                completion(judgeMunectingRank(status: statusCode, data: data))
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    func judgeMunectingRank(status: Int, data: Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<[MunectingRankData]>.self, from: data) else {return .pathErr}
        
        switch status {
        case 1000:
            return .success(decodedData.result)
        default:
            return .networkFail
        }
    }
    
    
}
