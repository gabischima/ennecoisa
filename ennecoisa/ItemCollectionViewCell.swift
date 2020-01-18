//
//  ItemCollectionViewCell.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 11/01/20.
//  Copyright © 2020 Gabriela Schirmer | MundiPagg. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.lightGray.cgColor
        }
    }

}
