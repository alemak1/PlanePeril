//
//  GKChasingEnemySun.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion

class GKChasingEnemySun: GKChasingEnemy{
    
    override init(texture: SKTexture, scalingFactor: CGFloat, defaultAction: SKAction, defaultActionName: String, size: CGSize?, position: CGPoint?, motionManager: CMMotionManager?) {
        
        super.init(texture: texture, scalingFactor: scalingFactor, defaultAction: defaultAction, defaultActionName: defaultActionName, size: size, position: position, motionManager: motionManager)
    }
    
    convenience init(scalingFactor: CGFloat, size: CGSize?, position: CGPoint?) {
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "sun1"))
        let defaultAction = SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "sun1")),
            SKTexture(image: #imageLiteral(resourceName: "sun2"))
            ], timePerFrame: 0.25)
        
        self.init(texture: texture, scalingFactor: scalingFactor, defaultAction: defaultAction, defaultActionName: "spinningAction", size: size, position: position, motionManager: nil)
        
        let radius = texture.size().width/4.0
        let physicsBody = SKPhysicsBody(circleOfRadius: radius)
        
        addPhysicsBodyComponent(physicsBody: physicsBody)
        
        addUpDownComponent()
        addAgentComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** A physics body must be passed in as an argument; since textures are available in the intialization function, texture size or the texture itself can be used to initialize a physics body
 
    **/
    func addPhysicsBodyComponent(physicsBody: SKPhysicsBody){
        let physicsBodyComponent = GKPhysicsBodyComponent(defaultPhysicsBody: physicsBody)
        addComponent(physicsBodyComponent)
        
        physicsBodyComponent.setParentPhysicsBodyToDefault()
        
        physicsBodyComponent.setPhysicsPropertiesFor(physicsBodyCategory: .Parent)
        
        
        //Set category/collision/contact bitmasks
        physicsBodyComponent.parentPhysicsBody?.categoryBitMask = PhysicsCategory.Enemy.rawValue
        physicsBodyComponent.parentPhysicsBody?.collisionBitMask = 0
        physicsBodyComponent.parentPhysicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue
        
        
    }
    
    func addUpDownComponent(){
        let upDownComponent = GKUpDownMoveComponent(upVelocity: 20.0, downVelocity: 5.0, maxPositiveDisplacement: 50.0, maxNegativeDisplacement: 60.0)
        addComponent(upDownComponent)
        
        
        let coinFlip: (Void)->(Void) = Int(arc4random_uniform(UInt32(2))) == 0 ? upDownComponent.startWithUpMovement : upDownComponent.startWithDownMovement
        
        coinFlip()
    }
    
}
