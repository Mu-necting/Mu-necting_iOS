//
//  ArchivePickCollectionViewCell.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/04.
//

import UIKit

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
}
