//
//  PickViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/04.
//

import UIKit

class PickViewController: UIViewController {

    @IBOutlet var musicView: UIView!
    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 0.8
        textView.layer.borderColor = UIColor.gray.cgColor
        musicView.layer.cornerRadius = 8
        musicView.layer.borderWidth = 0.8
        musicView.layer.borderColor = UIColor.gray.cgColor
        
        textView.text = "내용을 입력하세요"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
    }
    
    @IBAction func pickButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension PickViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your text here"
            textView.textColor = UIColor.lightGray
        }
    }
}
