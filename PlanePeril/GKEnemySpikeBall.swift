//
//  GKEnemySpikeBall.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


import Foundation
import GameplayKit
import SpriteKit
import CoreMotion

class GKSpikeBall: GKEnemy{
    
    init(scalingFactor: CGFloat, position: CGPoint?) {
        
        print("Getting spikeball's texture..")
        let texture = SKTexture(image: #imageLiteral(resourceName: "spikeBall1"))
        let textureSize = texture.size()
        
        
        print("Getting the action for spikeball...")
        let spinAction = SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "spikeBall1")),
            SKTexture(image: #imageLiteral(resourceName: "spikeBall_2"))
            ], timePerFrame: 0.25)
        
        
        print("Initializing spikeball...")
        super.init(texture: texture, scalingFactor: scalingFactor, defaultAction: spinAction, defaultActionName: "spinAnimation", size: textureSize, position: position, motionManager: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
