//
//  SignUpResultViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/04.
//

import Foundation

import UIKit

class SignUpResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func onTapGoToLogin(_ sender: Any) {
        print("로그인 페이지로 돌아가기")
        
        self.navigationController?.popToRootViewController(animated: false)
    }
}

