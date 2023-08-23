//
//  ArchiveUploadDetailViewController.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/21.
//

import UIKit
import AVFoundation
import CoreImage

class ArchiveUploadDetailViewController: UIViewController {

    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var shadowImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var singerLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    
    var passAlbumImg: UIImage?
    var titleText: String?
    var singerText: String?
    var genreText: String?
    
    var startTransform = UIImageView().layer.presentation()?.transform
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        albumCoverImageView.image = passAlbumImg
        backgroundImg.image = passAlbumImg
        
        titleLbl.text = titleText
        singerLbl.text = singerText
        genreLbl.text = genreText
        
        //앨범 커버 원형으로 만들기
        albumCoverImageView.layer.cornerRadius = albumCoverImageView.frame.size.width/2
        albumCoverImageView.clipsToBounds = true
        
        shadowImg.layer.cornerRadius = albumCoverImageView.frame.size.width/2
        shadowImg.clipsToBounds = true
        
        //앨범 커버 360도 돌리기
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2) // 360도 회전 (2 * π 라디안)
        rotationAnimation.duration = 5.0 // 애니메이션 지속 시간 (초)
        rotationAnimation.repeatCount = .infinity // 무한 반복
        
        if let presentationLayer = albumCoverImageView.layer.presentation() {
            self.startTransform = presentationLayer.transform
        }
        albumCoverImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
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
