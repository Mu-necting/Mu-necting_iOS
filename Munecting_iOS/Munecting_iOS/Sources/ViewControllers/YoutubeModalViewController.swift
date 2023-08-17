//
//  YoutubeModalViewController.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/09.
//

import UIKit
import WebKit

class YoutubeModalViewController: UIViewController {
    
    var musicPull:String = ""
    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var thisView: UIView!
    override func viewDidLoad() {
        self.modalPresentationStyle = .pageSheet
        self.sheetPresentationController?.prefersGrabberVisible = true
        thisView.backgroundColor = UIColor.white
        thisView.layer.borderWidth = 0
        super.viewDidLoad()
        let request = URLRequest(url: URL(string:musicPull)!)
        webView.load(request)
    }

 


}
