//
//  BestMunectorCollectionViewCell.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/04.
//

import UIKit

class BestMunectorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userID: UILabel!
    @IBOutlet var heartCount: UILabel!
    @IBOutlet var pickCount: UILabel!
    

    required init?(coder: NSCoder){
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
}
