//
//  ViewController.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 08/01/20.
//  Copyright © 2020 Gabriela Schirmer | MundiPagg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var enneSectionsTabbar: UITabBar!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var sectionCollection: UICollectionView!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var hairImageView: UIImageView!
    @IBOutlet weak var shirtImageView: UIImageView!
    @IBOutlet weak var legsImageView: UIImageView!
    @IBOutlet weak var shoesImageView: UIImageView!
    @IBOutlet weak var enneView: UIView!
    
    /* Images */
    var images: [[UIImage]] = [
        [
            UIImage(named: "head_0")!,
            UIImage(named: "head_1")!,
            UIImage(named: "head_2")!
        ],
        [
            UIImage(named: "hair_0")!,
            UIImage(named: "hair_1")!,
            UIImage(named: "hair_2")!,
            UIImage(named: "hair_3")!,
            UIImage(named: "hair_4")!,
            UIImage(named: "hair_5")!
        ],
        [
            UIImage(named: "shirt_0")!,
            UIImage(named: "shirt_1")!,
            UIImage(named: "shirt_2")!,
            UIImage(named: "shirt_3")!
        ],
        [
            UIImage(named: "legs_0")!,
            UIImage(named: "legs_1")!,
            UIImage(named: "legs_2")!
        ],
        [
            UIImage(named: "shoes_0")!,
            UIImage(named: "shoes_1")!,
            UIImage(named: "shoes_2")!
        ]
    ]
    
    enum Sections: Int, CaseIterable {
        case head, hair, shirt, legs, shoes
    }

    /* Active Set */
    
    
    // array of image of active set
    var activeSet = [UIImage()]
    // name of active set
    var activeSection = Sections.head
    // active image for each set
    var activeImages = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enneSectionsTabbar.delegate = self
        self.enneSectionsTabbar.selectedItem = self.enneSectionsTabbar.items?[0]
        self.sectionCollection.delegate = self
        self.sectionCollection.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "0")
        self.sectionCollection.allowsMultipleSelection = false
        
        Sections.allCases.forEach { (section) in
            self.activeImages.append("\(section)_")
        }
        self.activeSet = self.images[0]
        self.activeSection = Sections.head
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func saveImage(_ sender: Any) {
        // get images
        let eye: UIImage? = UIImage(named: "eye")

        let head: UIImage? = UIImage(named: self.activeImages[0])
        let hair: UIImage? = UIImage(named: self.activeImages[1])
        let shirt: UIImage? = UIImage(named: self.activeImages[2])
        let legs: UIImage? = UIImage(named: self.activeImages[3])
        let shoes: UIImage? = UIImage(named: self.activeImages[4])

        let size = CGSize(width: 750, height: 1334)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        eye?.draw(in: areaSize)
        hair?.draw(in: areaSize, blendMode: .normal, alpha: 1)
        head?.draw(in: areaSize, blendMode: .normal, alpha: 1)
        shoes?.draw(in: areaSize, blendMode: .normal, alpha: 1)
        legs?.draw(in: areaSize, blendMode: .normal, alpha: 1)
        shirt?.draw(in: areaSize, blendMode: .normal, alpha: 1)

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // save in contents directory
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePathToWrite = "\(paths)/image.png"
        let imageData: Data = newImage.pngData()!
        fileManager.createFile(atPath: filePathToWrite, contents: imageData, attributes: nil)
    }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.activeSection = Sections(rawValue: item.tag)!
        self.activeSet = self.images[item.tag]
        self.sectionCollection.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activeSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "0", for: indexPath) as! ItemCollectionViewCell
        let name = "\(self.activeSection)_\(String(indexPath.row))"
        cell.thumbnail.image = UIImage(named: "\(name)_icon")
        if let _ = self.activeImages.firstIndex(of: name) {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
        } else {
            cell.isSelected = false
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        return cell
    }
    
    private func collectionView(collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: false)
                return false
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageView = self.enneView.viewWithTag(self.activeSection.rawValue) as? UIImageView
        let activeIndex = self.activeSection.rawValue
        if (self.activeImages[activeIndex] == "\(self.activeSection)_\(String(indexPath.row))") {
            self.activeImages[activeIndex] = "\(self.activeSection)_"
            imageView?.image = nil
        } else {
            imageView?.image = self.images[activeIndex][indexPath.row]
            self.activeImages[activeIndex] = "\(self.activeSection)_\(String(indexPath.row))"
        }
    }
}
