import Alamofire
import Foundation

struct MunectingRankService{
    static let shared = MunectingRankService()
    
    
    func searchMunectingRank(rank: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        print("=======searchMunectingRank In==========")
        
        let url = "\(APIConstants.searchMunectingRank)?rank=\(rank)"
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        let dataRequest = AF.request(url,
                                     method: .get,
                                     headers: header)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                print("=======response.result == success ==========")
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeMunectingRank(status: statusCode, data: data))
            case .failure(let error):
                print("=======response.result == failure ==========")
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    func judgeMunectingRank(status: Int, data: Data) -> NetworkResult<Any>{
        print("=======judgeMunectingRank In==========")
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<[MunectingRankData]>.self, from: data) else {return .pathErr}
        print("=======Decode 성공==========")
        switch decodedData.code {
        case 1000:
            return .success(decodedData.result)
        default:
            return .networkFail
        }
    }
    
    
}
