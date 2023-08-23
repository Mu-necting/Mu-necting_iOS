//
//  LoginViewControllers.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/07/24.
//

import Foundation
import UIKit
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    // 튜토리얼 봤었는지 확인
    var isShownTutorial : Bool = false

    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var kakaoLoginButton: UIImageView!
    let loginPageStoryboard : UIStoryboard = UIStoryboard(name: "LoginPage", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        let tapKakaoButton = UITapGestureRecognizer(target: self, action: #selector(onTapKakaoLogin))
        kakaoLoginButton.addGestureRecognizer(tapKakaoButton)
        kakaoLoginButton.isUserInteractionEnabled = true
        
        isShownTutorial = UserDefaults.standard.bool(forKey: "isShownTutorial")
        
    }
    
    @objc func onTapKakaoLogin(_ sender: UITapGestureRecognizer) {
        onTouchSignUpWithKakao()
    }
    
    @IBAction func onTapLogin(_ sender: Any) {
        
        let email : String = idTextField.text ?? ""
        let password : String = passwordTextField.text ?? ""
        
        if(email == "" || password == ""){
            showAlert(title: "로그인 요청 오류", message: "아이디 혹은 패스워드를 입력해주세요")
            return
        }
        
        LoadingIndicator.showLoading()
        
        LoginService.login(email: email, password: password){
            (networkResult) in
            switch networkResult{
            case .success(let data):
                let tokens : [Token] = data as! [Token]
                
                for token : Token in tokens {
                    KeyChain().create(key: token.types, token: token.token)
                }
                
                UserManager.shared.setUser(User(userID: 0, userName: ""))
                
                self.goToMainPage()
                
            case .requestErr(let msg):
                if let message = msg as? String {
                    self.showAlert(title: "로그인 오류", message: "이메일이나 비밀번호를 확인해주세요.")
                    break
                }
            case .pathErr:
                print("pathErr in loginAPI")
                break
            case .networkFail:
                self.showAlert(title: "네트워크 오류", message: "네트워크 연결 상태를 확인해주세요")
                break
            case .serverErr:
                break
            }
            LoadingIndicator.hideLoading()

        }
    }
    
    
    @IBAction func onTapSignUp(_ sender: Any) {
        presentSignUpModal()
    }
    
    
    @IBAction func onTapFindPwd(_ sender: Any) {
        guard let viewController = loginPageStoryboard.instantiateViewController(identifier: "FindPasswordViewController") as? FindPasswordViewController else {return}
            self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func presentSignUpModal() {
        
        let signUpModal = UIViewController()
        signUpModal.view.backgroundColor = UIColor(hexCode: "D9D9D9")
        signUpModal.modalPresentationStyle = .pageSheet
        signUpModal.navigationItem.title = "간단한 회원가입"
        
        if let sheet = signUpModal.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        // 모달의 타이틀
        let modalTitle: UILabel = {
                let lb = UILabel()
                lb.text = "간단한 회원가입"
                lb.textAlignment = .center
                lb.font = .boldSystemFont(ofSize: 20)
                lb.textColor = .black

                return lb
            }()
        
        // 카카오 회원가입 이미지
        let signUpWithKakaoImageView: UIImageView = {
               let imageView = UIImageView()
               //표시될 UIImage 객체 부여
               imageView.image = UIImage(named: "kakao_singUp_medium_wide")
               imageView.contentMode = .scaleAspectFill

               return imageView
           }()
    
        signUpWithKakaoImageView.translatesAutoresizingMaskIntoConstraints = false
        signUpWithKakaoImageView.contentMode = .scaleAspectFill
        signUpWithKakaoImageView.isUserInteractionEnabled = true
        signUpWithKakaoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTouchSignUpWithKakao)))
        
        signUpWithKakaoImageView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        signUpWithKakaoImageView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        // 이메일 회원가입 버튼
        let signUpWithEmailButton = UIButton(type: .system)
        signUpWithEmailButton.addTarget(self, action: #selector(onTouchSignUpWithEmail), for: .touchUpInside)
        
        let buttonTextAttributes: [NSAttributedString.Key: Any] = [
                  .font: UIFont.boldSystemFont(ofSize: 15), // 볼드 글꼴 설정
                  .foregroundColor: UIColor.gray, // 텍스트 색상을 회색으로 설정
                  .underlineStyle: NSUnderlineStyle.single.rawValue // 밑줄 설정
              ]
        
        let attributedTitle = NSAttributedString(string: "이메일로 회원가입하기", attributes: buttonTextAttributes)
        
        signUpWithEmailButton.setAttributedTitle(attributedTitle, for: .normal)

        // 스택뷰
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [ signUpWithKakaoImageView, signUpWithEmailButton])
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 24
            stackView.axis = .vertical
            return stackView
        }()
        
        signUpModal.view.addSubview(modalTitle)
        signUpModal.view.addSubview(stackView)

        // AutoLayout
        modalTitle.translatesAutoresizingMaskIntoConstraints = false
        
        modalTitle.topAnchor.constraint(equalTo: signUpModal.view.topAnchor, constant: 30).isActive = true
        modalTitle.centerXAnchor.constraint(equalTo:signUpModal.view.centerXAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerXAnchor.constraint(equalTo: signUpModal.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: signUpModal.view.centerYAnchor).isActive = true
        
        
        present(signUpModal, animated: true, completion: nil)
    }

    @objc private func onTouchSignUpWithEmail() {
    // 버튼 액션 처리
        dismiss(animated: false)
                
        guard let viewController = loginPageStoryboard.instantiateViewController(identifier: "SignUpWithEmailViewController") as? SignUpWithEmailViewController else {return}
         self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func onTouchSignUpWithKakao() {
    // 버튼 액션 처리
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                  
                    LoginService.loginWithSocial(accessToken: oauthToken!.accessToken){
                        (networkResult) in
                        switch networkResult{
                        case .success(let data):
                            let tokens : [Token] = data as! [Token]
                            
                            for token : Token in tokens {
                                KeyChain().create(key: token.types, token: token.token)
                            }
                            
                            UserManager.shared.setUser(User(userID: 0, userName: ""))
                            self.goToMainPage()
                            
                        case .requestErr(let msg):
                            if let message = msg as? String {
                                print(message)
                                self.showAlert(title: "Error", message: message)
                            }
                        case .pathErr:
                            print("pathErr in loginWithSocialAPI")
                        case .serverErr:
                            self.showAlert(title: "내부 서버 오류", message: "잠시 후 다시 시도해주세요")
                            print("serverErr in loginWithSocialAPI")
                        case .networkFail:
                            self.showAlert(title: "네트워크 오류", message: "네트워크 연결 상태를 확인해주세요")
                            print("networkFail in loginWithSocialAPI")
                        }
                    }
                }
            }
        }else{
            if let presentedViewController = self.presentedViewController {
                dismiss(animated: false)
            }
            showAlert(title: "카카오 로그인 오류", message: "카카오톡을 설치해주세요.")
        }
    }
    
    @objc private func goToMainPage(){
        if(isShownTutorial){
            // 튜토리얼 봤었으면 메인페이지로
            let homeVC =  UIStoryboard(name: "Home", bundle: nil)
                .instantiateViewController(withIdentifier: "PageViewController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeVC, animated: true)
                    
        }else{
            // 처음이면 튜토리얼 페이지로
            UserDefaults.standard.set(true, forKey: "isShownTutorial")
            let tutorialVC =  UIStoryboard(name: "Tutorial", bundle: nil)
                .instantiateViewController(withIdentifier: "TutorialViewController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tutorialVC, animated: true)
            
        }
        
    }
    
    func showAlert(title: String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
    }

}
