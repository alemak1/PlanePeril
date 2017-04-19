//
//  NGKCollisionConfiguration.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class NGKPhysicsCategory{
    static let Player: UInt32 = 0b1 << 0
    static let Letter: UInt32 = 0b1 << 1
    static let Enemy: UInt32 =  0b1 << 2
    static let Barrier: UInt32 = 0b1 << 3
    static let Collectible: UInt32 = 0b1 << 4
    static let NoncollidingEnemy: UInt32 = 0b1 << 5
    static let Portal: UInt32 = 0b1 << 6
    
}

struct NGKCollisionConfiguration: Hashable{
    
    var rawValue: UInt32
    
    init(){
        rawValue = 0 << 0
    }
    
    init(rawValue: UInt32){
        self.rawValue = rawValue
    }
    
    
    //MARK: Conformance to Hashable Protocol
    
    var hashValue: Int{
        return Int(rawValue)
    }
    
    //MARK: SKPhysics Properties
    
    var categoryMask: UInt32{
        return rawValue
    }
    
    var collisionMask: UInt32{
        let mask = NGKCollisionConfiguration.definedCollision[self]?.map({$0.rawValue}).reduce(0, { return $0 | $1 })
        
        return mask ?? 0
        
    }
    
    var contactMask: UInt32{
        let mask = NGKCollisionConfiguration.definedContacts[self]?.map({$0.rawValue}).reduce(0, { return $0 | $1})
        
        return mask ?? 0
    }
}

extension NGKCollisionConfiguration: OptionSet{
    
}


//MARK:     Static Variables: DefinedContacts and DefinedCollisions Dict

extension NGKCollisionConfiguration{
    
    static let NoCategory = NGKCollisionConfiguration()
    static let Player = NGKCollisionConfiguration(rawValue: 1 << 0)
    static let Letter = NGKCollisionConfiguration(rawValue: 1 << 1)
    static let Enemy = NGKCollisionConfiguration(rawValue: 1 << 2)
    static let Barrier = NGKCollisionConfiguration(rawValue: 1 << 3)
    static let Collectible = NGKCollisionConfiguration(rawValue: 1 << 4)
    static let NonCollidingEnemy = NGKCollisionConfiguration(rawValue: 1 << 5)
    static let Portal = NGKCollisionConfiguration(rawValue: 1 << 6)
    
    static let definedCollision: [NGKCollisionConfiguration:[NGKCollisionConfiguration]] = [
        NGKCollisionConfiguration.Player :
                                            [NGKCollisionConfiguration.Enemy,                                    NGKCollisionConfiguration.Barrier],
        
        NGKCollisionConfiguration.Enemy :
                                            [NGKCollisionConfiguration.Player, NGKCollisionConfiguration.Barrier],
        NGKCollisionConfiguration.Barrier :
                                            [NGKCollisionConfiguration.Player, NGKCollisionConfiguration.Enemy],
        
        NGKCollisionConfiguration.NonCollidingEnemy : [NGKCollisionConfiguration.NoCategory]
    ]
    
    static let definedContacts: [NGKCollisionConfiguration:[NGKCollisionConfiguration]] = [
        NGKCollisionConfiguration.Player :
                                            [NGKCollisionConfiguration.Portal, NGKCollisionConfiguration.Collectible, NGKCollisionConfiguration.Letter, NGKCollisionConfiguration.Enemy, NGKCollisionConfiguration.NonCollidingEnemy],
        
        NGKCollisionConfiguration.NonCollidingEnemy:
                                                [NGKCollisionConfiguration.Player],
        
        NGKCollisionConfiguration.Portal :      [NGKCollisionConfiguration.Player]
    ]
    
}
