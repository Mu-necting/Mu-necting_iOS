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
}

