//
//  GKMadFly.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import CoreMotion


class GKMadFly: GKEnemy{
    
    override init(texture: SKTexture, scalingFactor: CGFloat, defaultAction: SKAction, defaultActionName: String, size: CGSize?, position: CGPoint?, motionManager: CMMotionManager?) {
        
        
        super.init(texture: texture, scalingFactor: scalingFactor, defaultAction: defaultAction, defaultActionName: defaultActionName, size: size, position: position, motionManager: motionManager)
        
        addFlyAgentComponent()
    }
    
    convenience init(scalingFactor: CGFloat, size: CGSize?, position: CGPoint?) {
        
        let defaultTexture = SKTexture(image: #imageLiteral(resourceName: "flyFly1"))
        let defaultAnimation = SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "flyFly1")),
            SKTexture(image: #imageLiteral(resourceName: "flyFly2"))
            ], timePerFrame: 0.25)
        
     
        self.init(texture: defaultTexture, scalingFactor: scalingFactor, defaultAction: defaultAnimation, defaultActionName: "flyingAction", size: size, position: position, motionManager: nil)
        
        let radius = defaultTexture.size().width/2.00
        let physicsBody = SKPhysicsBody(circleOfRadius: radius)
        let physicsComponent = GKPhysicsBodyComponent(defaultPhysicsBody: physicsBody)
        addComponent(physicsComponent)
        physicsComponent.setPhysicsPropertiesFor(physicsBodyCategory: .Parent, affectedByGravity: false, allowsRotation: false)
        physicsComponent.parentPhysicsBody?.velocity = CGVector(dx: -5.00, dy: -5.00)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addFlyAgentComponent(){
        let flyAgentComponent = GKFlyAgent()
        addComponent(flyAgentComponent)
    }
    
    
    
   
}
