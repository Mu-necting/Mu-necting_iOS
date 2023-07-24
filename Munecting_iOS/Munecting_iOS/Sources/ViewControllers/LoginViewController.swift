//
//  LoginViewControllers.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/07/24.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var kakaoLoginButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapKakaoButton = UITapGestureRecognizer(target: self, action: #selector(onTapKakaoLogin))
        kakaoLoginButton.addGestureRecognizer(tapKakaoButton)
        kakaoLoginButton.isUserInteractionEnabled = true
        
    }
    
    @objc func onTapKakaoLogin(_ sender: UITapGestureRecognizer) {
        print("클릭됨")
    }
    
    @IBAction func onTapLogin(_ sender: Any) {
        print("그냥 로그인")
    }
    
    
    @IBAction func onTapSignUp(_ sender: Any) {
        print("회원가입")
    }
    
    
    @IBAction func onTapFindEmail(_ sender: Any) {
        print("이메일 찾기")
    }
    
    @IBAction func onTapFindPwd(_ sender: Any) {
        print("비밀번호 찾기")
    }
    

//    @IBAction func presentModal(_ sender: Any) {
//          guard let viewController = storyboard?.instantiateViewController(identifier: "ModalViewController") as? ModalViewController else {
//              return
//          }
//
//          // delegate에 있는 방식을 사용하고 싶기 때문에 .custom 사용
//          viewController.modalPresentationStyle = .custom
//          // 어떤 방식으로 커스텀을 정의할 지 된 sldeInTransitioningDelegate에 위임한다
//          viewController.transitioningDelegate = slideInTransitioningDelegate
//          // 모달을 띄운다
//          self.present(viewController, animated: true, completion: nil)
//      }
}
