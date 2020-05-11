//
//  ViewController.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 08/01/20.
//  Copyright © 2020 Gabriela Schirmer | MundiPagg. All rights reserved.
//

import UIKit
import PencilKit

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
    
    @IBOutlet weak var toggleShake: ShakeItButton!
    @IBOutlet weak var toggleCanvas: ToggleCanvasButton!
    
    @IBOutlet weak var eraserConstraint: NSLayoutConstraint!
    @IBOutlet weak var pencilConstraint: NSLayoutConstraint!
    
    
    var canvasView: PKCanvasView!

    enum Tools: Int {
        case pencil, eraser
    }
    
    let eraserTool = PKEraserTool(.bitmap)
    let pencilTool = PKInkingTool(.pencil, color: .black, width: 6)
    
    var currentTool: Tools = Tools.pencil

    var canShakeItToShuffle: Bool = true
    /*
     * Images
     * head = 0
     * hair = 1
     * shirt = 2
     * legs = 3
     * shoes = 4
     */
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
            UIImage(named: "hair_5")!,
            UIImage(named: "hair_6")!,
            UIImage(named: "hair_7")!,
            UIImage(named: "hair_8")!,
            UIImage(named: "hair_9")!,
            UIImage(named: "hair_10")!
        ],
        [
            UIImage(named: "shirt_0")!,
            UIImage(named: "shirt_1")!,
            UIImage(named: "shirt_2")!,
            UIImage(named: "shirt_3")!,
            UIImage(named: "shirt_4")!,
            UIImage(named: "shirt_5")!
        ],
        [
            UIImage(named: "legs_0")!,
            UIImage(named: "legs_1")!,
            UIImage(named: "legs_2")!,
            UIImage(named: "legs_3")!
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
    // array of image for active set
    var activeSet = [UIImage()]
    // string for name of active set
    var activeSection = Sections.head
    // selected image for each set
    var selectedImages = [String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
        
        /* collection view */
        self.sectionCollection.delegate = self
        self.sectionCollection.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "0")
        self.sectionCollection.allowsMultipleSelection = false
        
        Sections.allCases.forEach { (section) in
            self.selectedImages.append("\(section)_")
        }
        self.activeSet = self.images[0]
        self.activeSection = Sections.head
        
        setupCanvasView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && self.toggleShake.isOn {
            shuffleAction()
            animateEnneView()
        }
    }
    
    func setupTabbar() {
        self.enneSectionsTabbar.delegate = self
        self.view.bringSubviewToFront(self.enneSectionsTabbar)
        self.enneSectionsTabbar.selectedItem = self.enneSectionsTabbar.items?[0]
        // remove tabbar border
        self.enneSectionsTabbar.layer.borderWidth = 0.50
        self.enneSectionsTabbar.layer.borderColor = UIColor.clear.cgColor
        self.enneSectionsTabbar.clipsToBounds = true
    }
    
    func setupCanvasView() {
        let canvasView = PKCanvasView(frame: self.enneView.bounds)
        self.canvasView = canvasView
        self.enneView.addSubview(canvasView)
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: self.enneView.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: self.enneView.bottomAnchor),
            canvasView.rightAnchor.constraint(equalTo: self.enneView.rightAnchor),
            canvasView.leftAnchor.constraint(equalTo: self.enneView.leftAnchor)
        ])
        
        canvasView.overrideUserInterfaceStyle = .light
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.tool = self.pencilTool
        self.currentTool = .pencil
        
        // setup apple pencil interaction
        let interaction = UIPencilInteraction()
        interaction.delegate = self
        view.addInteraction(interaction)
    }
    
    func animateEnneView() {
        let midX = self.enneView.center.x
        let midY = self.enneView.center.y

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 4, y: midY)
        animation.toValue = CGPoint(x: midX + 4, y: midY)
        self.enneView.layer.add(animation, forKey: "position")
    }
    
    func changeTool (_ tool: Int) {
        switch tool {
        case Tools.pencil.rawValue:
            self.canvasView.tool = self.pencilTool
            self.currentTool = Tools.pencil
            self.eraserConstraint.constant = -20.0
            self.pencilConstraint.constant = 0.0
        case Tools.eraser.rawValue:
            self.canvasView.tool = self.eraserTool
            self.currentTool = Tools.eraser
            self.eraserConstraint.constant = 0.0
            self.pencilConstraint.constant = -20.0
        default:
            break
        }
        UIView.animate(withDuration: Double(0.2), animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    /* MARK: IBAction */
    
    @IBAction func saveImage(_ sender: Any) {
        // get images
        let eye: UIImage? = UIImage(named: "enneeye")

        let head: UIImage? = UIImage(named: self.selectedImages[0])
        let hair: UIImage? = UIImage(named: self.selectedImages[1])
        let shirt: UIImage? = UIImage(named: self.selectedImages[2])
        let legs: UIImage? = UIImage(named: self.selectedImages[3])
        let shoes: UIImage? = UIImage(named: self.selectedImages[4])

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
    
    @IBAction func shuffleAction() {
        Sections.allCases.forEach { (section) in
            let img = Int(arc4random_uniform(UInt32(self.images[section.rawValue].count)))
            self.selectedImages[section.rawValue] = "\(section)_\(img)"
            if let imageView = self.enneView.viewWithTag(section.rawValue) as? UIImageView {
                imageView.image = self.images[section.rawValue][img]
            }
        }
        self.sectionCollection.reloadData()
    }
    
    @IBAction func toggleCanvasAction(_ sender: Any) {
        if (self.toggleCanvas.isOn) {
            self.canvasView.isUserInteractionEnabled = true
        } else {
            self.canvasView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func changeToolAction(_ sender: UIButton) {
        self.changeTool(sender.tag)
    }
    
}

extension ViewController: UIPencilInteractionDelegate {
    func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        if (self.toggleCanvas.isOn) {
            var newTool = Int()
            if (self.currentTool == Tools.pencil) {
                newTool = Tools.eraser.rawValue
            } else {
                newTool = Tools.pencil.rawValue
            }
            self.changeTool(newTool)
        }
    }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.activeSection = Sections(rawValue: item.tag)!
        self.activeSet = self.images[item.tag]
        self.sectionCollection.reloadData()
        self.sectionCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
        self.sectionCollection.showsHorizontalScrollIndicator = false
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
        cell.thumbnail.alpha = 0.6
        if let _ = self.selectedImages.firstIndex(of: name) {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        } else {
            cell.isSelected = false
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let imageView = self.enneView.viewWithTag(self.activeSection.rawValue) as? UIImageView
        let activeIndex = self.activeSection.rawValue
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                self.selectedImages[activeIndex] = "\(self.activeSection)_"
                imageView?.image = nil
                collectionView.deselectItem(at: indexPath, animated: false)
                return false
            }
        }
        imageView?.image = self.images[activeIndex][indexPath.row]
        self.selectedImages[activeIndex] = "\(self.activeSection)_\(String(indexPath.row))"
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        return true
    }

}
