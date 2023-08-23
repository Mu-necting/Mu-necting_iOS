//
//  UploadViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/04.
//

import UIKit

class UploadViewController: UIViewController {
    @IBOutlet var hiphopButton: UIButton!
    @IBOutlet var rockButton: UIButton!
    @IBOutlet var baladButton: UIButton!
    @IBOutlet var classicButton: UIButton!
    @IBOutlet var popButton: UIButton!
    @IBOutlet var bluesButton: UIButton!
    @IBOutlet var rnbButton: UIButton!
    @IBOutlet var countryButton: UIButton!
    @IBOutlet var edmButton: UIButton!
    @IBOutlet var kpopButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var musicView: UIView!
    @IBOutlet var albumCover: UIImageView!
    var music: MusicForUpload?
    var genre: String = ""
    var genreButtons: [UIButton] = []
    
    

    let cornerRadius: CGFloat = 12
    var shadowOffset: CGSize = CGSize(width: 5, height: 5)
    var shadowOpacity: Float = 0.7
    var shadowRadius: CGFloat = 4.0
    let NavWhite = UIColor.navWhiteColor

    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.layer.cornerRadius = 8
        timeLabel.layer.borderColor = UIColor.gray.cgColor
        timeLabel.layer.borderWidth = 0.8
        
        albumCover.layer.cornerRadius = 8
        
        musicView.layer.cornerRadius = 8
        musicView.layer.borderColor = UIColor.systemGray5.cgColor
        musicView.layer.borderWidth = 1
        musicView.layer.shadowColor = self.NavWhite.cgColor
        musicView.layer.shadowOpacity = self.shadowOpacity
        musicView.layer.shadowOffset = self.shadowOffset
        musicView.layer.shadowRadius = self.cornerRadius
        musicView.layer.masksToBounds = false
        
        genreButtons = [self.hiphopButton,self.rockButton,self.baladButton,self.classicButton,self.popButton,
                            self.bluesButton, self.rnbButton, self.countryButton, self.edmButton, self.kpopButton]
        
        self.configureButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func configureButtons(){
        hiphopButton.subtitleLabel?.text = "hiphop"
        rockButton.subtitleLabel?.text = "rock"
        baladButton.subtitleLabel?.text = "balad"
        classicButton.subtitleLabel?.text = "classic"
        popButton.subtitleLabel?.text = "pop"
        bluesButton.subtitleLabel?.text = "blues"
        rnbButton.subtitleLabel?.text = "rnb"
        countryButton.subtitleLabel?.text = "country"
        edmButton.subtitleLabel?.text = "edm"
        kpopButton.subtitleLabel?.text = "kpop"
    }


    @IBAction func timeSlider(_ sender: UISlider) {
        let value = Int(sender.value)
        timeLabel.text = "\(String(value))시간"
    }

    @IBAction func tappedGenreButton(_ sender: UIButton) {
        if sender.tintColor == .black{
            sender.tintColor = .white
            sender.backgroundColor = .munectingPurple
            sender.layer.cornerRadius = 10
            self.genre = sender.subtitleLabel!.text!
            
            self.genreButtons.forEach{
                if($0 != sender){
                    $0.tintColor = .black
                    $0.backgroundColor = .white 
                }
            }
        }else{
            sender.tintColor = .black
            sender.backgroundColor =  .white
            self.genre = ""
        }
        
    }
    
    @IBAction func tappedUploadButton(_ sender: Any) {
        if genre == "" {
            showAlert(title: "장르를 설정해 주세요")
            return
        }
        let sb = UIStoryboard(name: "Home", bundle: nil)
        guard let viewController = sb.instantiateViewController(identifier: "PageViewController") as? PageViewController else {return}
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController, animated: true)

        
//        self.navigationController?.popToRootViewController(animated: true)
//
//        if let pageViewController = self.navigationController?.viewControllers.first as? PageViewController {
//            print("====pageViewController 형변환 성공========")
//            pageViewController.pageViewController.setViewControllers([pageViewController.dataViewControllers[1]], direction: .forward, animated: true, completion: nil)
//        }
    }
    
    //showAlert
    func showAlert(title: String, message: String? = nil) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
           alertController.addAction(okAction)
           present(alertController, animated: true, completion: nil)
    }
}
