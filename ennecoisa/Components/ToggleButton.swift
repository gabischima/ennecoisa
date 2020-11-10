//
//  ToggleButton.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 06/11/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

@IBDesignable class ToggleButton: UIButton {
    
    @IBInspectable
    var isOn: Bool = true {
        didSet(newValue) {
            activateButton(bool: newValue)
        }
    }

    @IBInspectable
    var imageOn: UIImage?

    @IBInspectable
    var imageOff: UIImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        activateButton(bool: isOn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activateButton(bool: isOn)
    }
    
    fileprivate func load() {
        activateButton(bool: isOn)
        addTarget(self, action: #selector(ToggleButton.buttonPressed), for: .touchUpInside)
    }

    @objc func buttonPressed() {
        isOn = !isOn
        activateButton(bool: isOn)
    }

    func activateButton(bool: Bool) {
        if bool {
            setImage(self.imageOn, for: UIControl.State.normal)
        } else {
            setImage(self.imageOff, for: UIControl.State.normal)
        }
    }
}
