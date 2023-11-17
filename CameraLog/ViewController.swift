//
//  ViewController.swift
//  CameraLog
//
//  Created by Giovanni Fusco on 2/28/20.
//  Copyright © 2020 Smith-Kettlewell Eye Research Institute. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet weak var sceneView: ARSKView!
    var logger : Logger = Logger()
    var sessionID : String = ""
    var frameRate : Int = 20
    var rec : Bool = false
    var saveImage : Bool = false
    var frameCnt : UInt64 = 0
    var lastProcessedFrameTime: TimeInterval = TimeInterval()
    // Time between Unix epcoh and iPhone system boot
    var offset = NSTimeIntervalSince1970 - ProcessInfo.processInfo.systemUptime
    var Dinger : SoundPlayer = SoundPlayer()
    var lastDingTime: TimeInterval = TimeInterval()

    @IBOutlet weak var recButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.session.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        logger.startSession(sessionID : sessionID, setImageSave: saveImage)
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravity

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    @IBAction func recPressed(_ sender: Any) {
        rec = !rec
        if rec{
            recButton.backgroundColor = .green
            recButton.setTitle("Pause Recording", for: .normal)
            self.Dinger.playRecording()
        }
        else{
            recButton.backgroundColor = .red
            recButton.setTitle("Start Recording", for: .normal)
            self.Dinger.playStopped()
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame){
       //print(1/(frame.timestamp-lastProcessedFrameTime))
       // print(1000.0/Double(frameRate))
        if rec && (frame.timestamp-lastProcessedFrameTime) >= (1/Double(frameRate) - 0.01){
//            logger.saveImage(imageToSave: frame.capturedImage, counter: frameCnt)
            frameCnt += 1
            logger.logData(currentARFrame: frame, cnt: frameCnt, uptimeOffset: self.offset)
            lastProcessedFrameTime = frame.timestamp
            
        }
        // Check if phone is too tilted
        let yaw = frame.camera.eulerAngles.x
        if rec && (abs(yaw) > 0.5 && (frame.timestamp-lastDingTime) >= 1) {
            lastDingTime = frame.timestamp
            if yaw > 0 {
                Dinger.playDing()
            } else {
                Dinger.playBuzz()
            }
        }
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
