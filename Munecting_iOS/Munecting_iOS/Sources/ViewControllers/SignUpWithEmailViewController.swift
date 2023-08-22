//
//  SignUpWithEmailViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/07/25.
//

import UIKit

class SignUpWithEmailViewController: UIViewController {

    @IBOutlet weak var verifiedMark: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    
    @IBOutlet weak var verifyNumberTextField: UITextField!
    
    private var verifyNumber : String = "default"
    
    private var isVerified = false
    
    let loginPageStoryboard : UIStoryboard = UIStoryboard(name: "LoginPage", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        verifiedMark.isHidden = true
        verifyNumberTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    
    @IBAction func onTapVerify(_ sender: Any) {
        if(emailTextField.text != nil){
            LoginService.mailCheck(email: emailTextField.text!){
                (networkResult) in
                switch networkResult{
                case .success(let data):
                    self.verifyNumber = data
                    self.emailTextField.isUserInteractionEnabled = false
                case .requestErr(let msg):
                    if let message = msg as? String { print(message) }
                case .pathErr:
                    print("pathErr in loginWithSocialAPI")
                case .serverErr:
                    print("serverErr in loginWithSocialAPI")
                case .networkFail:
                    print("networkFail in loginWithSocialAPI")
                }
            }
        }
    }
    
    
    @IBAction func onTapSignUp(_ sender: Any) {
        if(passwordTextField.text != passwordCheckTextField.text) ||
            (passwordTextField.text == ""){
            showAlert(title:"비밀번호 오류",message : "비밀번호를 정확히 입력해주세요." )
            return
        }
        
        if(!isVerified){
            showAlert(title:"이메일 인증 필요",message : "이메일 인증을 진행해주세요." )
            return
        }
        
        LoginService.signUp(email: emailTextField.text!, password: passwordTextField.text!){
             (networkResult) in
             switch networkResult{
             case .success(let data):
                 if(data){                     
                     guard let viewController = self.loginPageStoryboard.instantiateViewController(identifier: "SignUpResultViewController") as? SignUpResultViewController else {return}
                     self.navigationController?.pushViewController(viewController, animated: true)
                 }
             case .requestErr(let msg):
                 if let message = msg as? String { print(message) }
             case .pathErr:
                 print("pathErr in loginWithSocialAPI")
             case .serverErr:
                 print("serverErr in loginWithSocialAPI")
             case .networkFail:
                 print("networkFail in loginWithSocialAPI")
             }
         }
    }
    
    @objc private func didTextFieldChanged(){
        if(verifyNumberTextField.text == verifyNumber){
            verifiedMark.isHidden = false
            verifyNumberTextField.isUserInteractionEnabled = false
            isVerified = true
        }
    }
    
    func showAlert(title: String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
    }
}

