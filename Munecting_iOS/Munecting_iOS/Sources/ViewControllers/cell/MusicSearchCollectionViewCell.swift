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
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.systemGray5.cgColor
        self.contentView.layer.backgroundColor = UIColor.systemGray5.cgColor

    }
    
}
