//
//   AuthenticationPhoneViewController.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/07/25.
//

import UIKit

class FindPasswordViewController: UIViewController {
    
    let loginPageStoryboard : UIStoryboard = UIStoryboard(name: "LoginPage", bundle: nil)
    
    @IBOutlet weak var nextButton: UIButton!
    
    var isVerified = false
    
    private var verifyNumber : String

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(isVerified == false){
            nextButton.isEnabled = false
        }
    }
    
    
    @IBAction func onTapVerify(_ sender: Any) {
        
    }
    
    

    @IBAction func onTapNextButton(_ sender: Any) {
        let changePasswordPage = loginPageStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController")
        
        self.show(changePasswordPage, sender: self)
        
    }
    
}

