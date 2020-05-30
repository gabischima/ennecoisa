//
//  EnneSection.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 29/05/20.
//  Copyright © 2020 Gabriela Schirmer. All rights reserved.
//

import UIKit


enum EnneSections: Int, CaseIterable {
    case head, hair, shirt, legs, shoes
}

struct EnneSection: Equatable {
    let slug: String
    var icon: UIImage? {
        return UIImage(named: slug)
    }
    let size: Int
    var images: [EnneImage] {
        var arr: [EnneImage] = []
        for item in 0..<(size) {
            arr.append(EnneImage(slug: "\(slug)_\(item)"))
        }
        return arr
    }

    init(slug: String, size: Int) {
        self.slug = slug
        self.size = size
    }
    
    static func == (lhs: EnneSection, rhs: EnneSection) -> Bool {
        return lhs.slug == rhs.slug
    }
}

struct EnneImage {
    let slug: String
    var icon: UIImage? {
        return UIImage(named: "\(slug)_icon")
    }
    var image: UIImage? {
       return UIImage(named: "\(slug)")
   }
}
