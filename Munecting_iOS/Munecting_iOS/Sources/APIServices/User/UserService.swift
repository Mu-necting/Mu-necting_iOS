//
//  UserService.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/20.
//

import Foundation
import Alamofire

struct UserService {
    
    static func changeProfile(name: String, profileImage:UIImage?, completion: @escaping (NetworkResult<Any>) -> Void){
        
        var profile : UIImage
        if(profileImage == nil) {
            profile = UIImage(named: "profile")!
        }else{
            profile = profileImage!
        }
        
        
        let url = APIConstants.changeProfile
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "atk": KeyChain().read(key: "atk")!,
        ]
        
        let body : Parameters = ["name" : name]
        
        let request = AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in body {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = profile.pngData() {
                multipartFormData.append(image, withName: "profile", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header)
        
        
        request.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(GenericResponse<User>.self, from: data) else {return}
                
                switch statusCode {
                case 200:
                    completion(.success(decodedData.isSuccess))
                default:
                    completion(.networkFail)
                }
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    static func getProfile(completion: @escaping (NetworkResult<Any>) -> Void){
        let url = APIConstants.getProfile
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "atk": KeyChain().read(key: "atk")!,
        ]
        
        let request = AF.request(url,method: .get,headers: header)
        
        request.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(GenericResponse<User>.self, from: data) else {
                    return}
                
                switch statusCode {
                case 200:
                    completion(.success(decodedData.result))
                default:
                    completion(.networkFail)
                }
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
}
