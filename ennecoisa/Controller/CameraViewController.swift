//
//  ViewController.swift
//  ennecoisa
//
//  Created by Gabriela Schirmer Mauricio on 26/06/19.
//  Copyright © 2019 Gabriela Schirmer Mauricio. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class CameraViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        configureLighting()
        // show close btn if iOS < 13.0
        if #available(iOS 13, *) {
            self.closeBtn.isHidden = true
        } else {
            self.closeBtn.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func resetTrackingConfiguration() {
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            // failed to read them – crash immediately!
            fatalError("Couldn't load tracking images.")
        }

        configuration.trackingImages = trackingImages
        configuration.isAutoFocusEnabled = true
        sceneView.session.run(configuration)
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // create a plane
        let plane = SCNPlane(width: 750/57, height: 1334/57)
        
        // add image from directory to plane
        let fileName = "image.png"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + fileName
        plane.firstMaterial?.diffuse.contents = UIImage(contentsOfFile: path)
        
        // wrap the plane in a node and rotate it so it's facing us
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        
        // now wrap that in another node and send it back
        let node = SCNNode()
        node.addChildNode(planeNode)
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.feedbackView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 1.0)
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.05, delay: 0.1, options: .curveEaseOut, animations: {
            self.feedbackView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0)
        }, completion: nil)
    }

    func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Photo could not be saved", comment: ""), message: NSLocalizedString("Please, check permissions.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func takePicture(_ sender: Any) {
        let image = sceneView.snapshot()
        fadeIn()
        fadeOut()
        // save it to photo library
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else {
            // Error saving image
            showAlert()
            return
        }
        // Image saved successfully
    }
}
