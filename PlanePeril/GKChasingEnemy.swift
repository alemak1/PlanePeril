//
//  GKChasingEnemy.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion


class GKChasingEnemy: GKEnemy{
    
    override init(texture: SKTexture, scalingFactor: CGFloat, defaultAction: SKAction, defaultActionName: String, size: CGSize?, position: CGPoint?, motionManager: CMMotionManager?) {
        
        super.init(texture: texture, scalingFactor: scalingFactor, defaultAction: defaultAction, defaultActionName: defaultActionName, size: size, position: position)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAgentComponent(){
        let agentComponent = GKAgent2D()
        
        //agentComponent.maxSpeed = 3.00
        
        guard let playerAgentComponent = GKPlayerPlane.mainPlayer.component(ofType: GKAgent2D.self) else { return }
        
        let mainGoal = GKGoal(toInterceptAgent: playerAgentComponent, maxPredictionTime: 1.0)
        agentComponent.behavior = GKBehavior(goal: mainGoal, weight: 10.00)
        addComponent(agentComponent)
    }
}
