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
    
    
    let munectingPurple = UIColor(red: 0.298, green: 0.098, blue: 0.396, alpha: 0.85)
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.layer.cornerRadius = 8
        timeLabel.layer.borderColor = UIColor.gray.cgColor
        timeLabel.layer.borderWidth = 0.8
        musicView.layer.cornerRadius = 8
        musicView.layer.borderColor = UIColor.systemGray.cgColor
        musicView.layer.borderWidth = 1
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
