//
//  Constants.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 22/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

struct EnneImg {
    struct Size {
        static var virtual = CGSize(width: 750, height: 1334)
        static var physical = CGSize(width: 13.21, height: 23.5)
    }

    static var ratio: CGFloat {
        return Size.virtual.width / Size.virtual.height
    }

    /// Returns a new CGSize relative to EnneImg.ratio
    /// The new size is based on scaled to fit aspect
    ///
    /// - Parameters:
    ///     - transformFrom: original size to be transformed
    ///     - relativeTo: relative size used to resize
    ///     - relativeRatio: ratio used to compare with EnneImg.ratio
    static func newSize(transformFrom oldsize: CGSize, relativeTo: CGSize, withRatio relativeRatio: CGFloat) -> CGSize {
        var newSize = CGSize()
        if ratio > relativeRatio {
            newSize.height = oldsize.height * relativeTo.width / oldsize.width
            newSize.width = relativeTo.width
        } else {
            newSize.width = oldsize.width * relativeTo.height / oldsize.height
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
