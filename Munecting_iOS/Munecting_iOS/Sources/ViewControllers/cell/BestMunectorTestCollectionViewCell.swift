//
//  BestMunectorTestCollectionViewCell.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/17.
//

import UIKit

class BestMunectorTestCollectionViewCell: UICollectionViewCell {
    @IBOutlet var rankingLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userIDLabel: UILabel!
    @IBOutlet var replyCntLabel: UILabel!
    @IBOutlet var pickCntLabel: UILabel!
    @IBOutlet var coverBackgroundView: UIView!
    
    let cornerRadius: CGFloat = 12
    var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    var shadowOpacity: Float = 0.5
    var shadowRadius: CGFloat = 4.0
    
    override init(frame: CGRect) {
         super.init(frame: frame)
     }
    
    
    required init?(coder: NSCoder){
        super.init(coder: coder)

    }
    
    func commmonInit(){
        self.userImage.layer.cornerRadius = 8
        self.coverBackgroundView.layer.cornerRadius = 8
        self.coverBackgroundView.layer.shadowColor = UIColor.navWhiteColor.cgColor
        self.coverBackgroundView.layer.shadowOpacity = self.shadowOpacity
        self.coverBackgroundView.layer.shadowOffset = self.shadowOffset
        self.coverBackgroundView.layer.shadowRadius = self.cornerRadius
//        layer.borderColor = UIColor.systemGray.cgColor

        
        
        
    }
    
    
    
}
