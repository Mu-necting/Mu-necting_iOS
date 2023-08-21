import Alamofire
import Foundation

struct MunectingMapService{
    static let shared = MunectingMapService()
    
    
    func searchMunectingMap(x: Double, y:Double, range: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = APIConstants.searchMunectingMap
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = [
            "x" : x,
            "y" : y,
            "range" : range
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
                completion(judgeSearchMunectingMap(status: statusCode, data: data))
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    func judgeSearchMunectingMap(status: Int, data: Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<[MunectingMapData]>.self, from: data) else {return .pathErr}
        
        switch status {
        case 1000:
            return .success(decodedData.result)
        default:
            return .networkFail
        }
    }
    
    
}
