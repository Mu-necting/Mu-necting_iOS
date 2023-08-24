//
//  ChangePasswordViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/17.
//

import Foundation

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    
    @IBOutlet weak var changeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.isEnabled = false
        passwordCheckTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }

    @IBAction func onTapChangeButton(_ sender: Any) {
        LoadingIndicator.showLoading()
        UserService.changePassword(newPassword: passwordTextField.text!, newPasswordCheck: passwordCheckTextField.text!){
            (networkResult) in
            switch networkResult{
            case .success(let data):
                let success = data as! Bool
                             if(success){
                                 self.showAlert(title: "성공", message: "비밀번호가 변경되었어요.")
                             }
            case .requestErr(let msg):
                             if let message = msg as? String { print(message) }
                             self.showAlert(title:"에러.",message : "비밀번호를 확인해주세요." )
            case .pathErr:
                             print("pathErr in loginWithSocialAPI")
                             self.showAlert(title:"ERROR",message : "에러." )
            case .serverErr:
                             print("serverErr in loginWithSocialAPI")
                             self.showAlert(title:"ERROR",message : "내부 서버 에러." )
            case .networkFail:
                             print("networkFail in loginWithSocialAPI")
                             self.showAlert(title:"ERROR",message : "네트워크 에러." )
                         }
            LoadingIndicator.hideLoading()
        }
    }
    
    
    @objc private func didTextFieldChanged(){
        if((passwordTextField.text == passwordCheckTextField.text) &&
           (passwordTextField.text != "")){
            changeButton.isEnabled = true
        }else{
            if(changeButton.isEnabled){
                changeButton.isEnabled = false
            }
        }
    }
    
    func showAlert(title: String, message : String){
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        let confirm = UIAlertAction(title: "확인", style: .default){
            _ in
            self.navigationController?.popViewController(animated: true)
        }
           
           alert.addAction(confirm)
           
           present(alert, animated: true, completion: nil)
       }
}

