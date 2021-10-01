//
//  EnneSection.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 29/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit

struct EnneSection: Equatable {
    let slug: String
    let icon: UIImage?
    let size: Int

    init(slug: String, size: Int) {
        self.slug = slug
        self.size = size
        self.icon = UIImage(named: self.slug)
    }
    
    static func == (lhs: EnneSection, rhs: EnneSection) -> Bool {
        return lhs.slug == rhs.slug
    }
}
