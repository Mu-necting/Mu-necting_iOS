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
    
    let cornerRadius: CGFloat = 12
    var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    var shadowOpacity: Float = 0.5
    var shadowRadius: CGFloat = 4.0
   

    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupCell()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        setupCell()


    }
    
    private func setupCell(){
        layer.cornerRadius = 8
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.shadowColor = UIColor.navWhiteColor.cgColor
        layer.shadowOpacity = self.shadowOpacity
        layer.shadowOffset = self.shadowOffset
        layer.shadowRadius = self.cornerRadius
        layer.masksToBounds = false
    }
    
}
