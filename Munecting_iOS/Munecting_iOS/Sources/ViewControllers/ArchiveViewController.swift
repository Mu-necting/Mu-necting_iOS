//
//  ArchiveViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/04.
//

import UIKit

class ArchiveViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var pickView: UIView!
    @IBOutlet weak var uploadView: UIView!
    
    let sb = UIStoryboard(name: "Home", bundle: nil)

    @IBAction func switchViews(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            pickView.alpha = 1.0
            uploadView.alpha = 0.0
        }
        else {
            pickView.alpha = 0.0
            uploadView.alpha = 1.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.selectedSegmentIndex = 0
        
        /*guard let viewController = sb.instantiateViewController(identifier: "PageViewController") as? PageViewController else {return}
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController, animated: true)*/
        
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
