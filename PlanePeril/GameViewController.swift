//
//  GameViewController.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit
import CoreMotion

class GameViewController: UIViewController {

    
    let mainMotionManager = MainMotionManager.sharedMotionManager

    
    /**
    let coreMotionHelper = CoreMotionHelper.sharedHelper
    **/
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Player.ConfigurePlaneAnimations()
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        mainMotionManager.startDeviceMotionUpdates()
        mainMotionManager.deviceMotionUpdateInterval = 0.50
    
    
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = SceneB(size: view.bounds.size)
            let ngkBaseScene = NGKBaseScene(size: view.bounds.size)
            let mapScene = MapScene(size: view.bounds.size)
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            ngkBaseScene.scaleMode = .aspectFill
            mapScene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(ngkBaseScene)
            
        
        
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
