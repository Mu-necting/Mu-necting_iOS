//
//  ArchiveFilterPopUpViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/14.
//

import UIKit

class ArchiveFilterPopUpViewController: UIViewController {

    @IBOutlet weak var bluesBtn: UIButton!
    @IBOutlet weak var popBtn: UIButton!
    @IBOutlet weak var balladBtn: UIButton!
    @IBOutlet weak var rnbBtn: UIButton!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var classicBtn: UIButton!
    @IBOutlet weak var edmBtn: UIButton!
    @IBOutlet weak var hiphopBtn: UIButton!
    @IBOutlet weak var kpopBtn: UIButton!
    @IBOutlet weak var rockBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var bgBtn: UIButton!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    var tapped = false
    var genreButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonView.layer.cornerRadius = 10
        buttonView.clipsToBounds = true
        
        shadowView.layer.cornerRadius = 10
        shadowView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        
        genreButtons = [self.bluesBtn,self.popBtn,self.balladBtn,self.rnbBtn,self.countryBtn,
                            self.classicBtn, self.edmBtn, self.hiphopBtn, self.kpopBtn, self.rockBtn]
    }
    
    @IBAction func tappedGenreButton(_ sender: UIButton) {
        if sender.tintColor == .black{
            sender.tintColor = .white
            sender.backgroundColor = .munectingPurple
            sender.layer.cornerRadius = 10
        }
            //self.genre = sender.subtitleLabel!.text!
            
            /*self.genreButtons.forEach{
                if($0 != sender){
                    $0.tintColor = .black
                    $0.backgroundColor = .white
                }
            }
        }else{
            sender.tintColor = .black
            sender.backgroundColor =  .white
            //self.genre = ""
        }*/
        
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
