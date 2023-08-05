//
//  SignUpWithEmailViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/07/25.
//

import UIKit

class SignUpWithEmailViewController: UIViewController {

    let loginPageStoryboard : UIStoryboard = UIStoryboard(name: "LoginPage", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapSignUp(_ sender: Any) {
        print("signUp 완료되면")
        
        let signUpResultPage = loginPageStoryboard.instantiateViewController(withIdentifier: "SignUpResultViewController")
        
        self.show(signUpResultPage, sender: self)
    }
}

