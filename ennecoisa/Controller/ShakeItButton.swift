//
//  ShakeItButton.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 24/01/20.
//  Copyright © 2020 Gabriela Schirmer | MundiPagg. All rights reserved.
//

import UIKit

class ShakeItButton: UIButton {
    var isOn: Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // init set img on
        activateButton(bool: isOn)
        addTarget(self, action: #selector(ShakeItButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        if isOn {
            self.setImage(UIImage(named: "shakeiton_btn") , for: UIControl.State.normal)
        } else {
            self.setImage(UIImage(named: "shakeitoff_btn") , for: UIControl.State.normal)
        }
    }    
}
