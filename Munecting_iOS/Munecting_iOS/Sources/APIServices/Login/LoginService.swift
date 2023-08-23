//
//  LoginService.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/14.
//

import Foundation
import Alamofire

struct LoginService{
    
    static func signUp(email:String, password:String, completion: @escaping (NetworkResult<Any>)->Void){
        
        let url = APIConstants.signUp
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = ["email" : email, "password" : password]
        
        let request = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
                    completion(.success(decodedData.isSuccess))
                case 500:
                    completion(.requestErr("Error"))
                default:
                    completion(.networkFail)
                }
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
        
        
    }
    
    static func login(email: String, password: String, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = APIConstants.login
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = ["email" : email, "password" : password]
        
        let request = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
                    
                    guard let decodedData = try? decoder.decode(GenericResponse<[Token]>.self, from: data) else {return}
                    
                    completion(.success(decodedData.result))
                case 500:
                    completion(.requestErr("Error"))
                default:
                    completion(.networkFail)
                }
                        
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        })
    }
    
    static func loginWithSocial(accessToken: String, completion: @escaping (NetworkResult<Any>) -> Void){
        let url = APIConstants.loginWithSocialURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = ["token" : accessToken]
        
        let request = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
                    guard let decodedData = try? decoder.decode(GenericResponse<[Token]>.self, from: data) else {return}
                    
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
    
    
    static func mailCheck(email: String, completion: @escaping (NetworkResult<String>) -> Void){
        let url = APIConstants.mailCheck
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = ["email" : email]
        
        let request = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
                    guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {return}
                    
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
    
    static func issueTempPassword(email: String, completion: @escaping (NetworkResult<Bool>) -> Void){
        let url = APIConstants.issueTempPassword
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = ["email" : email]
        
        let request = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
                    guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {return}
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
    
    static func logout(completion: @escaping (NetworkResult<Any>) -> Void){
        let url = APIConstants.logout
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "atk": KeyChain().read(key: "atk")!,
        ]
        
        let request = AF.request(url,
                                     method: .post,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
                    
                    guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {return}
                    
                    completion(.success(decodedData.isSuccess))
                case 500:
                    completion(.requestErr("Error"))
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
