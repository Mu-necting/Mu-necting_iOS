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
        presentSignUpModal()
//        let signUpModal = SignUpModalViewController()
//        if let sheet = signUpModal.sheetPresentationController {
//               sheet.detents = [.medium()]
//           }
//        self.present(signUpModal, animated: true)
    }
    
    
    @IBAction func onTapFindEmail(_ sender: Any) {
        print("이메일 찾기")
    }
    
    @IBAction func onTapFindPwd(_ sender: Any) {
        print("비밀번호 찾기")
    }
    
    @objc private func presentSignUpModal() {
        
        let signUpModal = UIViewController()
        signUpModal.view.backgroundColor = UIColor(hexCode: "D9D9D9")
        signUpModal.modalPresentationStyle = .pageSheet
        signUpModal.navigationItem.title = "간단한 회원가입"
        
        if let sheet = signUpModal.sheetPresentationController {
            
            //지원할 크기 지정
            sheet.detents = [.medium()]

           
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
        
        
        let modalTitle: UILabel = {
                let lb = UILabel()
                lb.text = "간단한 회원가입"
                lb.textAlignment = .center
                lb.font = .systemFont(ofSize: 30)
                lb.textColor = .black
                lb.backgroundColor = .red
                lb.frame = CGRect(x: 120, y: 50, width: 100, height: 50)
                
                return lb
            }()
        
        
        let button = UIButton(type: .system)
        button.setTitle("버튼", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 50) // 버튼의 프레임 설정
        signUpModal.view.addSubview(button)
        signUpModal.view.addSubview(modalTitle)

        present(signUpModal, animated: true, completion: nil)
    }

    @objc private func buttonTapped() {
    // 버튼 액션 처리
        print("모달 버튼")
    }

    

//    private func presentReviewModalViewController() {
//            let reviewModalStoryboard = UIStoryboard(name: Const.Storyboard.Name.reviewModal, bundle: nil)
//            guard let reviewModalViewController = reviewModalStoryboard.instantiateViewController(withIdentifier: Const.ViewController.Identifier.reviewModal) as? SignUpModalViewController else {
//                return
//            }
//
//            reviewModalViewController.modalPresentationStyle = .custom
//            reviewModalViewController.transitioningDelegate = self
//            present(reviewModalViewController, animated: true, completion: nil)
//    }
    
}
