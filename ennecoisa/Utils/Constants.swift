//
//  Constants.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 22/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

struct EnneImg {
    static var size: CGSize {
        return CGSize(width: 750, height: 1334)
    }
    static var physicalSize: CGSize {
        return CGSize(width: 13.21, height: 23.5)
    }
    static var ratio: CGFloat {
        return size.width / size.height
    }

    /// Returns a new CGSize relative to EnneImg.ratio.
    ///
    /// - Parameters:
    ///     - sizeToTransform: original size to be transformed
    ///     - relativeTo: relative size used to resize
    ///     - relativeRatio: ratio used to compare with EnneImg.ratio
    static func newSize(sizeToTransform: CGSize, relativeTo: CGSize, relativeRatio: CGFloat) -> CGSize {
        var newSize = CGSize()
        if ratio > relativeRatio {
            newSize.height = sizeToTransform.height * relativeTo.width / sizeToTransform.width
            newSize.width = relativeTo.width
        } else {
            newSize.width = sizeToTransform.width * relativeTo.height / sizeToTransform.height
            newSize.height = relativeTo.height
        }
        return newSize
    }
}

enum EnneSections: Int, CaseIterable {
    case head, face, hair, shirt, legs, shoes
}

enum ToolsPosition: Int {
    case left, right
}
