//
//  Constants.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 22/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

struct ARSize {
    static var device: CGSize {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return CGSize(width: 2388, height: 1482)
        case .phone:
            return CGSize(width: 750, height: 1196)
        default:
            return CGSize(width: 750, height: 1196)
        }
    }
}

enum EnneSections: Int, CaseIterable {
    case head, face, hair, shirt, legs, shoes
}

enum ToolsPosition: Int {
    case left, right
}
