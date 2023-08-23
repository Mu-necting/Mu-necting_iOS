import Alamofire
import Foundation

struct MusicReplyService{
    static let shared = MusicReplyService()
    struct EmptyResult: Codable {
        var url: String
    }
    
    //reply보내기
    func sendReply(archiveId: Int, memberId: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = "\(APIConstants.musicPullURL)?archiveId=\(archiveId)&memberId=\(memberId)"
        print("========sendReply In============")
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let dataRequest = AF.request(url,
                                     method: .post,
                                     headers: header)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                print("========response.result = success============")
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeSendReply(status: statusCode, data: data))
            case .failure(let error):
                print("========response.result = failure============")
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    //sednReply 판단
    func judgeSendReply(status: Int, data: Data) -> NetworkResult<Any>{
        print("========judgeSendReply In============")
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<EmptyResult>.self, from: data) else {return .pathErr}
        print("========decoding 성공============")
        switch decodedData.code {
        case 1000:
            print("========case 1000 In============")
            return .success(decodedData.result)
//            return .success(decodedData)
        default:
            print("========case 1000 In 실패============")
            return .networkFail
        }
    }
    
    //reply취소
    func cancelReply(archiveId: Int, memberId: Int, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = "\(APIConstants.cancelReplyURL)?archiveId=\(archiveId)&memberId=\(memberId)"
        
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let dataRequest = AF.request(url,
                                     method: .post,
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
                completion(judgeSendReply(status: statusCode, data: data))
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    //cancelReply 판단
    func judgeCancelReply(status: Int, data: Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<EmptyResult>.self, from: data) else {return .pathErr}
        print(decodedData)
        switch decodedData.code {
        case 1000:
            return .success(decodedData.result)
//            return .success(decodedData)
        default:
            return .networkFail
        }
    }
    
}
