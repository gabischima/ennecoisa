//
//  SetInterfaceDirection.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 30/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

protocol ConfigurationDelegate {
    func setToolsPosition(position: ToolsPosition)
    func saveEnneToCameraRoll() -> UIImage
}
