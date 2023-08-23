//
//  ArchiveDetailViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/13.
//

import UIKit

class ArchiveDetailViewController: UIViewController {
    
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var singerLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var dateLbl: UILabel!
    
    var passAlbumImg: UIImage?
    var titleText: String?
    var singerText: String?
    var genreText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        albumImg.image = passAlbumImg
        titleLbl.text = titleText
        singerLbl.text = singerText
        genreLbl.text = genreText
        
        albumImg.layer.cornerRadius = 10
    }
    
    func loadDetailData() {
        if let archiveDetail = ArchiveDetailManager.shared.archiveDetail {
            titleLbl.text = archiveDetail.name
            singerLbl.text = archiveDetail.artist
            detailTextView.text = archiveDetail.writing
            dateLbl.text = archiveDetail.createAt // This should be converted to a proper date format
        } else {
            // Handle when archiveDetail is not available
        }
    }
}
