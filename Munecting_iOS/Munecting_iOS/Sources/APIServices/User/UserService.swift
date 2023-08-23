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
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        let request = AF.upload(multipartFormData: { multipartFormData in
            if let json = jsonData {
                    multipartFormData.append(json, withName: "member", mimeType: "application/json")
                }
            
            if let image = profile.pngData() {
                print("여길 안들어옴")
                multipartFormData.append(image, withName: "profile", fileName: "\(name).png", mimeType: "image/png")
            }
            
           
        }, to: url, method: .post, headers: header)
        
        
        request.responseData(completionHandler: { (response) in
            switch response.result{
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                
                print(statusCode)
                switch statusCode {
                case 200:
                    guard let data = response.value else {
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    guard let decodedData = try? decoder.decode(GenericResponse<User>.self, from: data) else {return}
                    
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
                
                switch statusCode {
                case 200:
                    guard let data = response.value else {
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    guard let decodedData = try? decoder.decode(GenericResponse<User>.self, from: data) else {
                        return}
                    
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
