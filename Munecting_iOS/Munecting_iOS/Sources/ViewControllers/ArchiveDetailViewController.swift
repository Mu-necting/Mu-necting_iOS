//
//  ArchiveDetailViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/13.
//

import UIKit

class ArchiveDetailViewController: UIViewController {
    
    @IBOutlet weak var albumImg: UIImageView!
    
    var passAlbumImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        albumImg.image = passAlbumImg

    }
}
