//
//   AuthenticationPhoneViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/07/25.
//

import UIKit

class FindPasswordViewController: UIViewController {
    
//    let loginPageStoryboard : UIStoryboard = UIStoryboard(name: "LoginPage", bundle: nil)
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var verifyNumberTextField: UITextField!
    
    private var verifyNumber : String = "default"

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.isEnabled = false
        verifyNumberTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    
    
    @IBAction func onTapVerify(_ sender: Any) {
        if(emailTextField.text != nil){
            LoadingIndicator.showLoading()
            
            LoginService.mailCheck(email: emailTextField.text!){
                (networkResult) in
                switch networkResult{
                case .success(let data):
                    self.verifyNumber = data
                    self.emailTextField.isUserInteractionEnabled = false
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
    }
    
    

    @IBAction func onTapNextButton(_ sender: Any) {
        
        let email = emailTextField.text!
        if(verifyNumberTextField.text == verifyNumber){
            LoginService.issueTempPassword(email: email){
                (networkResult) in
                switch networkResult{
                case .success(let data):
                    if(data){
                        self.showTempPasswordAlert()
                    }
                case .requestErr(let msg):
                    if let message = msg as? String {
                        print(message)
                        self.showErrorAlert(title: "Error", message: message)
                    }
                case .pathErr:
                    print("pathErr in issueTempPasswordAPI")
                case .serverErr:
                    self.showErrorAlert(title: "내부 서버 오류", message: "잠시 후 다시 시도해주세요")
                    print("serverErr in issueTempPasswordAPI")
                case .networkFail:
                    self.showErrorAlert(title: "네트워크 오류", message: "네트워크 연결 상태를 확인해주세요")
                    print("networkFail in issueTempPasswordAPI")
                }
            }
        }
    }
    
    @objc private func didTextFieldChanged(){
        if(verifyNumberTextField.text == verifyNumber){
            confirmButton.isEnabled = true
        }else{
            if(confirmButton.isEnabled){
                confirmButton.isEnabled = false
            }
        }
    }
    
    func showTempPasswordAlert(){
        let alert = UIAlertController(title: "임시 비밀번호 발급", message: "이메일로 임시 비밀번호를 전송하였습니다. 임시 비밀번호로 로그인해주세요.", preferredStyle: .alert )
        let confirm = UIAlertAction(title: "로그인 하러 가기", style: .default){_ in
            self.navigationController?.popViewController(animated: false)
        }
        
        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        let confirm = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
    }
    
}

