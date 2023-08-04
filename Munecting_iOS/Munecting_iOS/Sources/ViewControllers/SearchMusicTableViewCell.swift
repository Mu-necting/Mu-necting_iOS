//
//  SearchMusicTableViewCell.swift
//  Munecting_iOS
//
//  Created by 이현호 on 2023/08/03.
//

import UIKit

class SearchMusicTableViewCell: UICollectionViewCell {

    @IBOutlet var albumImage: UIImageView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var musicNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
