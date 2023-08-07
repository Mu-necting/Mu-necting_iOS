//
//  UploadViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/04.
//

import UIKit

class UploadViewController: UIViewController {
    @IBOutlet var hiphopButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var musicView: UIView!
    
    static let NavWhite: UIColor = UIColor(named: "NavWhite")!

    let cornerRadius: CGFloat = 12
    var shadowColor: CGColor = UIColor.systemGray4.cgColor
    var shadowOffset: CGSize = CGSize(width: 5, height: 5)
    var shadowOpacity: Float = 0.7
    var shadowRadius: CGFloat = 4.0
    
    let munectingPurple = UIColor(red: 0.298, green: 0.098, blue: 0.396, alpha: 0.85)
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.layer.cornerRadius = 8
        timeLabel.layer.borderColor = UIColor.gray.cgColor
        timeLabel.layer.borderWidth = 0.8
        musicView.layer.cornerRadius = 8
        musicView.layer.borderColor = UIColor.systemGray.cgColor
        musicView.layer.borderWidth = 1
        
        musicView.layer.shadowColor = self.shadowColor
        musicView.layer.shadowOpacity = self.shadowOpacity
        musicView.layer.shadowOffset = self.shadowOffset
        musicView.layer.shadowRadius = self.cornerRadius
        musicView.layer.masksToBounds = false
       
    }


    @IBAction func timeSlider(_ sender: UISlider) {
        let value = Int(sender.value)
        timeLabel.text = "\(String(value))시간"
    }
    @IBAction func hiphopButton(_ sender: UIButton) {
        if sender.tintColor == .black{
            sender.tintColor = .white
            sender.backgroundColor = munectingPurple
            sender.layer.cornerRadius = 10
        }else{
            sender.tintColor = .black
            sender.backgroundColor = .white
        }
    }
}
/*
 self.button?.layer.shadowColor = self.shadowColor
 self.button?.layer.shadowOpacity = self.shadowOpacity
 self.button?.layer.shadowOffset = self.shadowOffset
 self.button?.layer.shadowRadius = self.shadowRadius
 self.button?.layer.masksToBounds = false
 */
