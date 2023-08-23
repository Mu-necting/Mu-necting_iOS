//
//  DeleteUserViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/24.
//

import Foundation

import UIKit

class DeleteUserViewController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapDeleteUserButton(_ sender: Any) {
        showAlert(title: "정말로 탈퇴하시겠습니까?", message: "탈퇴시 계정을 복구할 수 없습니다.12")
    }
    
    func showAlert(title: String, message : String){
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        let confirm = UIAlertAction(title: "확인", style: .default){
            _ in
            LoadingIndicator.showLoading()
            
            UserService.deleteUser{
                (networkResult) in
                switch networkResult{
                case .success(let data):
                    let success = data as! Bool
                    if(success){
                        KeyChain().delete(key: "atk")
                        if(KeyChain().read(key: "rtk") != nil){
                            KeyChain().delete(key: "rtk")
                        }
                        let LoginVC =  UIStoryboard(name: "LoginPage", bundle: nil)
                                        .instantiateViewController(withIdentifier: "LoginNavigationViewController")
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginVC, animated: true)
                    }
                case .requestErr(let msg):
                    if let message = msg as? String { print(message) }
                case .pathErr:
                    print("pathErr in mailCheckAPI")
                case .serverErr:
                    print("serverErr in mailCheckAPI")
                case .networkFail:
                    print("networkFail in mailCheckAPI")
                }
                
                LoadingIndicator.hideLoading()
            }
        }
           
           alert.addAction(confirm)
           
           present(alert, animated: true, completion: nil)
       }
}
