//
//  WidthControl.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 12/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

@IBDesignable
class WidthControl: UISlider {

    // required for IBDesignable class to properly render
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // required for IBDesignable class to properly render
    required override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBInspectable var thumbImage: UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }

    @IBInspectable var thumbHighlightedImage: UIImage? {
        didSet {
            setThumbImage(thumbHighlightedImage, for: .highlighted)
        }
    }

    @IBInspectable var minimumTrackImage: UIImage? {
        didSet {
            setMinimumTrackImage(minimumTrackImage, for: .normal)
        }
    }

    @IBInspectable var maximumTrackImage: UIImage? {
        didSet {
            setMaximumTrackImage(maximumTrackImage, for: .normal)
        }
    }
}
