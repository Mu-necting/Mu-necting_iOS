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
        
        // Add a tap gesture recognizer to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Set the delegate of the text field
        self.emailTextField.delegate = self
        
    }
    
    @objc func dismissKeyboard() {
            // Resign first responder status to dismiss the keyboard
        self.emailTextField.resignFirstResponder()
        view.endEditing(true)
        }
    
    @IBAction func onTapVerify(_ sender: Any) {
        if(emailTextField.text != nil){
            
            LoadingIndicator.showLoading()
            
            LoginService.mailCheck(email: emailTextField.text!){
                (networkResult) in
                switch networkResult{
                case .success(let data):
                    self.verifyNumber = data
//                    self.emailTextField.isUserInteractionEnabled = false
                    self.showAlert(title:"요청 완료",message : "메일로 인증번호가 전송되었어요." )
                case .requestErr(let msg):
                    if let message = msg as? String { print(message) }
                    self.showAlert(title:"요청 에러",message : "가입된 메일로 인증을 요청하세요." )
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
        
        LoadingIndicator.showLoading()
        
        LoginService.signUp(email: emailTextField.text!, password: passwordTextField.text!){
             (networkResult) in
             switch networkResult{
             case .success(let data):
                 let success = data as! Bool
                 if(success){                     
                     guard let viewController = self.loginPageStoryboard.instantiateViewController(identifier: "SignUpResultViewController") as? SignUpResultViewController else {return}
                     self.navigationController?.pushViewController(viewController, animated: true)
                 }
             case .requestErr(let msg):
                 if let message = msg as? String { print(message) }
                 self.showAlert(title:"이미 가입된 이메일 입니다.",message : "메일과 비밀번호를 확인해주세요." )
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
        if(verifyNumberTextField.text == verifyNumber){
            verifiedMark.isHidden = false
//            verifyNumberTextField.isUserInteractionEnabled = false
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

// UITextFieldDelegate method to dismiss keyboard when Return key is pressed
extension SignUpWithEmailViewController : UITextFieldDelegate{
    
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
  }
}
