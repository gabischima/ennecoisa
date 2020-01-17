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
    var head: [UIImage] = [
        UIImage(named: "head_0")!,
        UIImage(named: "head_1")!,
        UIImage(named: "head_2")!
    ]
    var hair: [UIImage] = [
        UIImage(named: "hair_0")!,
        UIImage(named: "hair_1")!,
        UIImage(named: "hair_2")!,
        UIImage(named: "hair_3")!,
        UIImage(named: "hair_4")!,
        UIImage(named: "hair_5")!
    ]
    var shirt: [UIImage] = [
        UIImage(named: "shirt_0")!,
        UIImage(named: "shirt_1")!,
        UIImage(named: "shirt_2")!,
        UIImage(named: "shirt_3")!
    ]
    var legs: [UIImage] = [
        UIImage(named: "legs_0")!,
        UIImage(named: "legs_1")!,
        UIImage(named: "legs_2")!
    ]
    var shoes: [UIImage] = [
        UIImage(named: "shoes_0")!,
        UIImage(named: "shoes_1")!,
        UIImage(named: "shoes_2")!
    ]
    
    /* Active Set */
    // array of image of active set
    var activeSet = [UIImage()]
    // name of active set [head|hair|shirt|legs|shoes]
    var activeSection = String()
    // active image for each set
    var activeImages = ["head_", "hair_", "shirt_", "legs_", "shoes_"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enneSectionsTabbar.delegate = self
        self.enneSectionsTabbar.selectedItem = self.enneSectionsTabbar.items?[0]
        self.activeSet = self.head
        self.activeSection = "head"
        self.sectionCollection.delegate = self
        self.sectionCollection.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "0")
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
        switch item.tag {
            case 0:
                self.activeSet = self.head
                self.activeSection = "head"
            case 1:
                self.activeSet = self.hair
                self.activeSection = "hair"
            case 2:
                self.activeSet = self.shirt
                self.activeSection = "shirt"
            case 3:
                self.activeSet = self.legs
                self.activeSection = "legs"
            case 4:
                self.activeSet = self.shoes
                self.activeSection = "shoes"
            default:
                self.activeSet = self.head
                self.activeSection = "head"
        }        
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
        let name = self.activeSection + "_" + String(indexPath.row) + "_icon"
        cell.thumbnail.image = UIImage(named: name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.activeSection {
            case "head":
                if (self.activeImages[0] == "head_" + String(indexPath.row)) {
                    self.headImageView.image = nil
                    self.activeImages[0] = "head_"
                } else {
                    self.headImageView.image = self.head[indexPath.row]
                    self.activeImages[0] = "head_" + String(indexPath.row)
                }
            case "hair":
                if (self.activeImages[1] == "hair_" + String(indexPath.row)) {
                    self.hairImageView.image = nil
                    self.activeImages[1] = "hair_"
                } else {
                    self.hairImageView.image = self.hair[indexPath.row]
                    self.activeImages[1] = "hair_" + String(indexPath.row)
                }
            case "shirt":
                if (self.activeImages[2] == "shirt_" + String(indexPath.row)) {
                    self.shirtImageView.image = nil
                    self.activeImages[2] = "shirt_"
                } else {
                    self.shirtImageView.image = self.shirt[indexPath.row]
                    self.activeImages[2] = "shirt_" + String(indexPath.row)
                }
            case "legs":
                if (self.activeImages[3] == "legs_" + String(indexPath.row)) {
                    self.legsImageView.image = nil
                    self.activeImages[3] = "legs_"
                } else {
                    self.legsImageView.image = self.legs[indexPath.row]
                    self.activeImages[3] = "legs_" + String(indexPath.row)
                }
            case "shoes":
                if (self.activeImages[4] == "shoes_" + String(indexPath.row)) {
                    self.shoesImageView.image = nil
                    self.activeImages[4] = "shoes_"
                } else {
                    self.shoesImageView.image = self.shoes[indexPath.row]
                    self.activeImages[4] = "shoes_" + String(indexPath.row)
                }
            default:
                break
        }
    }
}
