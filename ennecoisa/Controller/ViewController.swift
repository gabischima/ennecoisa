//
//  ViewController.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 08/01/20.
//  Copyright © 2020 Gabriela Schirmer | MundiPagg. All rights reserved.
//

import UIKit
import PencilKit

//MARK: - ViewController Properties
class ViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var enneSectionsTabbar: UITabBar!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var sectionCollection: UICollectionView!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var hairImageView: UIImageView!
    @IBOutlet weak var shirtImageView: UIImageView!
    @IBOutlet weak var legsImageView: UIImageView!
    @IBOutlet weak var shoesImageView: UIImageView!
    @IBOutlet weak var enneView: UIView!
    
    @IBOutlet weak var toggleShake: ToggleButton!
    @IBOutlet weak var toggleCanvas: ToggleButton!
    
    @IBOutlet weak var eraserTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var eraserLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pencilTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pencilLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var eraserBtn: UIButton!
    @IBOutlet weak var pencilBtn: UIButton!
    
    @IBOutlet weak var widthControl: WidthControl!
    
    @IBOutlet weak var toolsViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolsViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var shuffleViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var shuffleViewTrailingConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    var canvasView: PKCanvasView!

    enum Tools: Int {
        case pencil, eraser
    }
    
    let eraserTool = PKEraserTool(.bitmap)
    var pencilTool = PKInkingTool(.pencil, color: .black, width: 6)
    
    var currentTool: Tools = Tools.pencil
    
    var toolsPosition: ToolsPosition = .right

    /*
     * Images
     * head = 0
     * face = 1
     * hair = 2
     * shirt = 3
     * legs = 4
     * shoes = 5
     */
    var enneSections: [EnneSection] = [
        EnneSection(slug: "head", size: 5),
        EnneSection(slug: "face", size: 10),
        EnneSection(slug: "hair", size: 12),
        EnneSection(slug: "shirt", size: 9),
        EnneSection(slug: "legs", size: 6),
        EnneSection(slug: "shoes", size: 5)
    ]

    /* Active Set */
    // string for name of active set
    var activeSection = EnneSections.head
    // selected image for each set
    var selectedImages: [String] = []

}

//MARK: - ViewController functions
extension ViewController {

    //MARK: - View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
        
        /* collection view */
        self.sectionCollection.delegate = self
        self.sectionCollection.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "0")
        self.sectionCollection.allowsMultipleSelection = false
        
        EnneSections.allCases.forEach { (section) in
            self.selectedImages.append("\(section)_")
        }
        
        if let str = UserDefaults.standard.string(forKey: "toolsPosition"), let position = Int(str) {
            toolsPosition = ToolsPosition(rawValue: position) ?? .right
            setToolsPosition(position: toolsPosition)
        }


        self.activeSection = EnneSections.head
        
        setupCanvasView()
        
        self.widthControl.value = 6.0
    }
    
    //MARK: - Motion method
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && self.toggleShake.isOn {
            shuffleAction()
            animateEnneView()
        }
    }
    
    //MARK: - Setup methods
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

        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            canvasView.allowsFingerDrawing = true
        }
        
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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let undoGesture = UITapGestureRecognizer(target: self, action: #selector(undoAction(_:)))
            undoGesture.numberOfTouchesRequired = 2
            
            let redoGesture = UITapGestureRecognizer(target: self, action: #selector(redoAction(_:)))
            redoGesture.numberOfTouchesRequired = 3
            
            let tapGestures: [UIGestureRecognizer] = [undoGesture, redoGesture]
            for tap in tapGestures {
                view.addGestureRecognizer(tap)
            }
        }

        self.canvasView.isUserInteractionEnabled = self.toggleCanvas.isOn
    }
    
    //MARK: - Functions
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
    
///TODO: component
    func changeTool (_ tool: Int) {
        switch tool {
        case Tools.pencil.rawValue:
            self.canvasView.tool = self.pencilTool
            self.currentTool = Tools.pencil
            self.eraserTrailingConstraint.constant = -20.0
            self.pencilTrailingConstraint.constant = 0.0
            self.eraserLeadingConstraint.constant = -20.0
            self.pencilLeadingConstraint.constant = 0.0
        case Tools.eraser.rawValue:
            self.canvasView.tool = self.eraserTool
            self.currentTool = Tools.eraser
            self.eraserTrailingConstraint.constant = 0.0
            self.pencilTrailingConstraint.constant = -20.0
            self.eraserLeadingConstraint.constant = 0.0
            self.pencilLeadingConstraint.constant = -20.0
        default:
            break
        }
        UIView.animate(withDuration: Double(0.2), animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConfig" {
            if let nextViewController = segue.destination as? ConfigViewController {
                nextViewController.delegate = self
                nextViewController.toolsPosition = self.toolsPosition
            }
        }
    }
    
    func mergeImages (toAR: Bool) -> UIImage {
        let head: UIImage? = UIImage(named: self.selectedImages[0])
        let face: UIImage? = UIImage(named: self.selectedImages[1])
        let hair: UIImage? = UIImage(named: self.selectedImages[2])
        let shirt: UIImage? = UIImage(named: self.selectedImages[3])
        let legs: UIImage? = UIImage(named: self.selectedImages[4])
        let shoes: UIImage? = UIImage(named: self.selectedImages[5])

        let screenScale = UIScreen.main.scale

        let canvasImage: UIImage! = self.canvasView.drawing.image(from: self.canvasView.frame, scale: screenScale)

        var contextSize = CGSize()

        var enneSize = CGSize(width: 750, height: 1334)
        var canvasSize = CGSize(width: canvasImage.size.width, height: canvasImage.size.height)
        let canvasRatio = canvasSize.width / canvasSize.height

        if toAR {
            // context is canvas size relative to enne fixed size w 750 x h 1334
            canvasSize = EnneImg.newSize(sizeToTransform: canvasSize, relativeTo: enneSize, relativeRatio: canvasRatio)
            contextSize = canvasSize
        } else {
            // context is device size in scale
            let screenBounds = UIScreen.main.bounds
            let screenScale = UIScreen.main.scale
            contextSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)
            // canvas size is relative to context
            canvasSize.height = canvasSize.height * contextSize.width / canvasSize.width
            canvasSize.width = contextSize.width
            // enne img is relative to canvas
            enneSize = EnneImg.newSize(sizeToTransform: enneSize, relativeTo: canvasSize, relativeRatio: canvasRatio)
        }

        UIGraphicsBeginImageContext(contextSize)
        
        let enneRect = CGRect(origin: CGPoint(x: (contextSize.width - enneSize.width) / 2, y: (contextSize.height - enneSize.height) / 2), size: enneSize)
        let canvasRect = CGRect(origin: CGPoint(x: (contextSize.width - canvasSize.width) / 2, y: (contextSize.height - canvasSize.height) / 2), size: canvasSize)

///TEST: fill size to check proportions
//        let context = UIGraphicsGetCurrentContext()!
//        context.setFillColor(UIColor.black.cgColor)
//        context.fill(enneRect)
//
//        context.setFillColor(UIColor(red: 1, green: 0, blue: 0, alpha: 0.3).cgColor)
//        context.fill(canvasRect)

        if (!toAR) {
            let enne: UIImage? = UIImage(named: "base")
            enne?.draw(in: enneRect)
        }

        face?.draw(in: enneRect)
        hair?.draw(in: enneRect, blendMode: .normal, alpha: 1)
        head?.draw(in: enneRect, blendMode: .normal, alpha: 1)
        shoes?.draw(in: enneRect, blendMode: .normal, alpha: 1)
        legs?.draw(in: enneRect, blendMode: .normal, alpha: 1)
        shirt?.draw(in: enneRect, blendMode: .normal, alpha: 1)
        canvasImage?.draw(in: canvasRect, blendMode: .normal, alpha: 1)

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
    
//    MARK: - IBAction
    /**
    Save image for AR visualization
    - parameter sender: The element responsable for triggering the function.
    */

    @IBAction func saveImageToAR(_ sender: Any) {
        // get combined images
        let newImage = mergeImages(toAR: true)
        
        // save in contents directory
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePathToWrite = "\(paths)/image.png"
        let imageData: Data = newImage.pngData()!
        fileManager.createFile(atPath: filePathToWrite, contents: imageData, attributes: nil)
    }
    
    @IBAction func shuffleAction() {
        for (i, section) in self.enneSections.enumerated() {
            let j = Int(arc4random_uniform(UInt32(section.images.count)))
            self.selectedImages[i] = section.images[j].slug
            if let imageView = self.enneView.viewWithTag(i) as? UIImageView {
                imageView.image = section.images[j].image
            }
        }
        self.sectionCollection.reloadData()
    }
    
    @IBAction func toggleCanvasAction(_ sender: Any) {
        self.canvasView.isUserInteractionEnabled = self.toggleCanvas.isOn
    }
    
    @IBAction func changeToolAction(_ sender: UIButton) {
        self.changeTool(sender.tag)
    }
    
    @IBAction func undoAction(_ sender: Any) {
        if let _ = self.canvasView.undoManager?.canUndo {
            self.canvasView.undoManager?.undo()
        }
    }
    
    @IBAction func redoAction(_ sender: Any) {
        if let _ = self.canvasView.undoManager?.canRedo {
            self.canvasView.undoManager?.redo()
        }
    }
    
    @IBAction func changeWidthValue(_ sender: WidthControl) {
        self.pencilTool.width = CGFloat(sender.value)
        self.changeTool(Tools.pencil.rawValue)
    }
    
}

//MARK: - UITabBarDelegate
extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (self.activeSection == EnneSections(rawValue: item.tag)!) {
            self.sectionCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: true)
        } else {
            self.activeSection = EnneSections(rawValue: item.tag)!
            self.sectionCollection.reloadData()
            self.sectionCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
            self.sectionCollection.showsHorizontalScrollIndicator = false
            
        }
    }
}

///TODO: Separate delegate / datasource
//MARK: - Collection View
//      - UICollectionViewDelegate
//      - UICollectionViewDataSource
//      - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.enneSections[self.activeSection.rawValue].size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "0", for: indexPath) as! ItemCollectionViewCell
        let enneimg = self.enneSections[self.activeSection.rawValue].images[indexPath.row]
        cell.thumbnail.image = enneimg.icon
        cell.thumbnail.alpha = 0.6
        if let _ = self.selectedImages.firstIndex(of: enneimg.slug) {
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
        imageView?.image = self.enneSections[activeIndex].images[indexPath.row].image
        self.selectedImages[activeIndex] = self.enneSections[activeIndex].images[indexPath.row].slug
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        return true
    }

}

//MARK: - UIPencilInteractionDelegate
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

//MARK: - ConfigurationDelegate
extension ViewController: ConfigurationDelegate {
    func setToolsPosition(position: ToolsPosition) {
        toolsPosition = position
        UserDefaults.standard.set(String(position.rawValue), forKey: "toolsPosition")
        switch position {
        case .right:
            toolsViewLeadingConstraint.priority = UILayoutPriority(rawValue: 1)
            shuffleViewTrailingConstraint.priority = UILayoutPriority(rawValue: 1)
            toolsViewTrailingConstraint.priority = UILayoutPriority(rawValue: 1000)
            shuffleViewLeadingConstraint.priority = UILayoutPriority(rawValue: 1000)
            eraserLeadingConstraint.priority = UILayoutPriority(rawValue: 1)
            pencilLeadingConstraint.priority = UILayoutPriority(rawValue: 1)
            eraserTrailingConstraint.priority = UILayoutPriority(rawValue: 1000)
            pencilTrailingConstraint.priority = UILayoutPriority(rawValue: 1000)
            self.eraserBtn.imageView?.transform = CGAffineTransform(rotationAngle: 0)
            self.pencilBtn.imageView?.transform = CGAffineTransform(rotationAngle: 0)
        case .left:
            toolsViewTrailingConstraint.priority = UILayoutPriority(rawValue: 1)
            shuffleViewLeadingConstraint.priority = UILayoutPriority(rawValue: 1)
            toolsViewLeadingConstraint.priority = UILayoutPriority(rawValue: 1000)
            shuffleViewTrailingConstraint.priority = UILayoutPriority(rawValue: 100)
            eraserTrailingConstraint.priority = UILayoutPriority(rawValue: 1)
            pencilTrailingConstraint.priority = UILayoutPriority(rawValue: 1)
            eraserLeadingConstraint.priority = UILayoutPriority(rawValue: 1000)
            pencilLeadingConstraint.priority = UILayoutPriority(rawValue: 1000)
            self.eraserBtn.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
            self.pencilBtn.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
        }
        self.view.layoutIfNeeded()
    }

    func saveEnneToCameraRoll() -> UIImage {
        return mergeImages(toAR: false)
    }
    
    func clearCanvas() {
        canvasView.clearCanvas()
    }
}
