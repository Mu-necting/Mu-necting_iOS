//
//  MusicSearchCollectionViewCell.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/03.
//

import UIKit

class MusicSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var musicTitleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var backView: UIView!
    
    let cornerRadius: CGFloat = 12
    var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    var shadowOpacity: Float = 0.5
    var shadowRadius: CGFloat = 4.0
   

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        


    }
    
    func setupCell(){
        backView.layer.cornerRadius = 8
        backView.layer.borderWidth = 1.0
        backView.layer.borderColor = UIColor.white.cgColor
        backView.layer.shadowColor = UIColor.navWhiteColor.cgColor
        backView.layer.shadowOpacity = self.shadowOpacity
        backView.layer.shadowOffset = self.shadowOffset
        backView.layer.shadowRadius = self.cornerRadius
        backView.layer.masksToBounds = false
        albumImageView.layer.cornerRadius = 8
        albumImageView.tintColor = .systemGray
        albumImageView.backgroundColor = .systemGray
    }
    
}
