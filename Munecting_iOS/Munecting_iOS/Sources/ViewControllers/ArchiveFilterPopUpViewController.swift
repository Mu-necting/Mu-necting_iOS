//
//  ArchiveFilterPopUpViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/14.
//

import UIKit

class ArchiveFilterPopUpViewController: UIViewController {

    @IBOutlet weak var popBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var bgBtn: UIButton!
    
    var tapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func popBtnTapped(_ sender: UIButton) {
        
        if tapped {
            popBtn.backgroundColor = UIColor.black // 원하는 배경색으로 변경
            
            tapped = false
        }
        else {
            popBtn.backgroundColor = UIColor.red
            
            tapped = true
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bgBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
