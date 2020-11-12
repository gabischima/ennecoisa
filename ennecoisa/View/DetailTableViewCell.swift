//
//  DetailTableViewCell.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 09/11/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
       super.awakeFromNib()
        selectionStyle = .none
    }
}
