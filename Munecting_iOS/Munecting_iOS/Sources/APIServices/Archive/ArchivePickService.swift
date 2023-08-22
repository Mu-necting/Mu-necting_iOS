//
//  ArchivePickService.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/22.
//

import Foundation
import Alamofire

struct ArchivePickService {
    
    // Pick 상세조회 (GET)
    static func ArchivePickDetail(pickId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.baseURL + "/pick/\(pickId)/detail"
        
        print(url)
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     encoding: URLEncoding.default,
                                     headers: nil)
        
        dataRequest.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                
                print("Received response with Status Code: \(statusCode)")
                
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(GenericResponse<ArchiveDetail>.self, from: data) else {return}
                
                switch statusCode {
                case 200..<300: completion(.success(decodedData.isSuccess))
                case 400..<500: completion(.requestErr(decodedData))
                case 500..<600: completion(.serverErr)
                default: completion(.networkFail)
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.networkFail)
            }
        })
    }
}
