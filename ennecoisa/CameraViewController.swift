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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        configureLighting()
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
        sceneView.session.run(configuration)
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // make sure this is an image anchor, otherwise bail out
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        // create a plane at the exact physical width and height of our reference image
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.height, height: imageAnchor.referenceImage.physicalSize.height)
        
        // make the plane have a transparent blue color
        plane.firstMaterial?.diffuse.contents = UIImage(named: "rawr")
        
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
}
