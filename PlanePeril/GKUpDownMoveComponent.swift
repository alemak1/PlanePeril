//
//  GKUpDownMoveComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class GKUpDownMoveComponent: GKComponent{
    
    var upVelocity: CGFloat
    var downVelocity: CGFloat
    
    var maxUpDisplacement: CGFloat
    var maxDownwardDisplacement: CGFloat
    
    /** Parent physics body is only accessible until after component is added to an entity
 
    **/
    var parentPhysicsBody: SKPhysicsBody?{
        get{
            if let parentEntity = self.entity,let spriteComponent = parentEntity.component(ofType: GKSpriteComponent.self){
                return spriteComponent.node.physicsBody
            }
                
            return nil
        }
        
      
    }
    
    var currentPosition: CGPoint?{
        get{
            if let parentEntity = self.entity, let node = parentEntity.component(ofType: GKSpriteComponent.self)?.node{
                return node.position
            }
            
            return nil
        }
    }
    
    
    init(upVelocity: CGFloat, downVelocity: CGFloat, maxPositiveDisplacement: CGFloat, maxNegativeDisplacement: CGFloat) {
        
        self.upVelocity = upVelocity
        self.downVelocity = downVelocity
        
        self.maxDownwardDisplacement = maxNegativeDisplacement
        self.maxUpDisplacement = maxPositiveDisplacement
        
        super.init()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let currentPosition = currentPosition, let physicsBody = parentPhysicsBody else { return }
        
        if(currentPosition.y > maxUpDisplacement + currentPosition.y){
            physicsBody.velocity.dy =  -downVelocity
        }
        
        if(currentPosition.y <  currentPosition.y - maxDownwardDisplacement){
            physicsBody.velocity.dy = upVelocity
        }
        
    }
    
    func startWithUpMovement(){
        
        parentPhysicsBody?.velocity = CGVector(dx: 0.0, dy: upVelocity)
    }
    
    func startWithDownMovement(){
        parentPhysicsBody?.velocity = CGVector(dx: 0.0, dy: -downVelocity)
    }
    
    
}
