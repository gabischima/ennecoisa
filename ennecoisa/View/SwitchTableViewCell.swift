//
//  SwitchTableViewCell.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 30/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var interfaceSwitch: UISegmentedControl!

    override func awakeFromNib() {
       super.awakeFromNib()
        selectionStyle = .none
    }
}
