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
    var icon: UIImage?
    let size: Int
    var images: [EnneImage] = []

    init(slug: String, size: Int) {
        self.slug = slug
        self.size = size
        self.setImages()
    }
    
    private mutating func setImages () {
        var arr: [EnneImage] = []

        for item in 0..<(self.size) {
            arr.append(EnneImage(slug: "\(self.slug)_\(item)"))
        }
        
        self.images = arr
        self.icon = UIImage(named: self.slug)
    }
    
    static func == (lhs: EnneSection, rhs: EnneSection) -> Bool {
        return lhs.slug == rhs.slug
    }
}

struct EnneImage {
    let slug: String
    var icon: UIImage?
    var image: UIImage?

    init(slug: String) {
        self.slug = slug
        self.setImages()
    }
    
    private mutating func setImages () {
        self.image = UIImage(named: "\(slug)")
        self.icon = UIImage(named: "\(slug)_icon")
    }
}
