import Alamofire
import Foundation

struct MusicSearchService{
    static let shared = MusicSearchService()
    
    
    func searchMusic(searchKeyword: String, page: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = "\(APIConstants.searchMusicURL)?search=\(searchKeyword)&page=\(page)"
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        let dataRequest = AF.request(url,
                                     method: .get,
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
                completion(judgeSearchMusic(status: statusCode, data: data))
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    func judgeSearchMusic(status: Int, data: Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<MusicSearchResult>.self, from: data) else {return .pathErr}
        print(status)
        
        var resultStatus = decodedData.code
        switch resultStatus {
        case 1000:
            return .success(decodedData.result)
        default:
            return .networkFail
        }
    }
    
    
}
