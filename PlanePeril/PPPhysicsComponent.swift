//
//  PPPhysicsComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class PPPhysicsComponent: GKComponent{
    
    //MARK: Properties
    
    var physicsBody: SKPhysicsBody
    
    //MARK:  Initializers 
    
    init(physicsBody: SKPhysicsBody, collisionConfiguration: CollisionConfiguration){
        self.physicsBody = physicsBody
        
        self.physicsBody.categoryBitMask = collisionConfiguration.categoryMask
        self.physicsBody.collisionBitMask = collisionConfiguration.collisionMask
        self.physicsBody.contactTestBitMask = collisionConfiguration.contactMask
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
