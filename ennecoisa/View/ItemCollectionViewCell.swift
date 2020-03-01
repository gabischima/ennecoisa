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
    @IBOutlet weak var selectedImage: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            self.selectedImage.image = isSelected ? UIImage(named: "selected_image") : nil
            self.thumbnail.alpha = isSelected ? 1.0 : 0.6
        }
    }

}
