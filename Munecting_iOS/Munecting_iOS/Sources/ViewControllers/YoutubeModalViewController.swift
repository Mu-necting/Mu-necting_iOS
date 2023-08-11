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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string:musicPull)!)
        webView.load(request)
    }
    
 


}
