//
//  SceneA.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class SceneA: EnemyAgentScene{
    
    var lastUpdateTime: TimeInterval = 0.00
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let player = GKPlayerPlane(planeType: .Blue, scalingFactor: 0.80, motionManager: MainMotionManager.sharedMotionManager, position: CGPoint.zero, size: nil)
        
      //  let sunPos = CGPoint(x: 30, y: 50)
      //  let enemySun = GKEnemySun(scalingFactor: 0.50, position: sunPos)
        
       // let spikeBallPos = CGPoint(x: 50, y: -30)
       // let spikeBall = GKSpikeBall(scalingFactor: 0.40, position: spikeBallPos)
        
       // entitiesManager.add(player)
       // entitiesManager.add(enemySun)
       // entitiesManager.add(spikeBall)
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
   
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        super.update(currentTime)
        
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        entitiesManager.update(dt)
        
        
    }
}
