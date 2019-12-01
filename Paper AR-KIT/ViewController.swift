//
//  ViewController.swift
//  Paper AR-KIT
//
//  Created by Himanshu Mehta on 2019-11-27.
//  Copyright © 2019 Himanshu Mehta. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //ARImageTrackingConfiguration used to Track the image
        let configuration = ARImageTrackingConfiguration()

        // This is to check if AR Resource is nil then get out of that function
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        else{
            return
        }
        
        // If Ar resources is not nill
        configuration.trackingImages = arImages
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // here checking wheather anchor is ar-image anchor
        //then only actually we can say we found the image
        guard anchor is ARImageAnchor
            else {
            return
        }
        
        //container
        // if anchor is Ar-anchor then
        // we get the container
        
        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false)   //in this it ask us do you find us to find the container on the serface level of highest tear of scene graph
            // we set as false because it is on surface level
            else {
            return
        }
        
        container.removeFromParentNode()
        // we can move the image around and container will alsomove around with it
        node.addChildNode(container)
        container.isHidden = false
        
        //video
        let videoURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let videoPlayer = AVPlayer(url: videoURL)
        
        let videoScene = SKScene(size: CGSize(width: 720.0, height: 1280.0))
        
        let videoNode = SKVideoNode(avPlayer: videoPlayer)
        videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
        videoNode.size = videoScene.size
        videoNode.size = videoScene.size
        videoNode.yScale = -1
        
        videoScene.addChild(videoNode)
        
        guard let video = container.childNode(withName: "video", recursively: false)
            else {
                return
        }
        video.geometry?.firstMaterial?.diffuse.contents = videoScene
        
    }
    
    
    
    
    
    
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
