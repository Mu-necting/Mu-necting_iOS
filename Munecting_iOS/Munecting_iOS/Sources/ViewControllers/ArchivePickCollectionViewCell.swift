//
//  ArchivePickCollectionViewCell.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/04.
//

import UIKit
import Alamofire
import AlamofireImage

class ArchivePickCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var highlightView: UIView!
    
    override var isHighlighted: Bool {
            didSet {
                highlightView.isHidden = !isHighlighted
            }
        }
        
    override var isSelected: Bool {
        didSet {
            highlightView.isHidden = !isSelected
            //selectIndicator.isHidden = !isSelected
        }
    }
    
    // coverImg를 표시하는 함수
    func displayCoverImage(fromURL urlString: String) {
        if let coverImgURL = URL(string: urlString) {
            AF.request(coverImgURL).responseImage { response in
                switch response.result {
                case .success(let image):
                    self.albumImg.image = image
                case .failure(let error):
                    print("Error downloading cover image: \(error)")
                }
            }
        }
    }
}
