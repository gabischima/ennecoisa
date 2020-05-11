//
//  ToggleCanvasButton.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 10/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

class ToggleCanvasButton: UIButton {
    var isOn: Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // init set img on
        activateButton(bool: isOn)
        addTarget(self, action: #selector(ToggleCanvasButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        if isOn {
            self.setImage(UIImage(named: "pencilon_btn") , for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "penciloff_btn") , for: UIControl.State.normal)
        }
    }
}
