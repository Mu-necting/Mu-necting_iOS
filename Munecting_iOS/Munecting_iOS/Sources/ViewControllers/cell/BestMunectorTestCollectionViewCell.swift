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
    
    var shadowOffset: CGSize = CGSize(width: 5, height: 5)
    var shadowOpacity: Float = 0.7
    var shadowRadius: CGFloat = 4.0
    
    override init(frame: CGRect) {
         super.init(frame: frame)
     }
    
    
    required init?(coder: NSCoder){
        super.init(coder: coder)

    }
    
    func commmonInit(){
        self.userImage.layer.cornerRadius = 10
        self.coverBackgroundView.layer.cornerRadius = 10
//        self.coverBackgroundView.layer.borderWidth = 1
//        self.coverBackgroundView.layer.borderColor = UIColor.munectingPink.cgColor
//        self.coverBackgroundView.layer.shadowColor = UIColor.black.cgColor
//        self.coverBackgroundView.layer.shadowOpacity = self.shadowOpacity
//        self.coverBackgroundView.layer.shadowOffset = self.shadowOffset
//        layer.borderColor = UIColor.systemGray.cgColor

        
        
        
    }
    
    
    
}
