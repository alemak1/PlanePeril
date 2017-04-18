//
//  ColliderType.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


struct CollisionConfiguration{
    
    
    //MARK: OptionSet Protocol Conformance
    
    var rawValue: UInt32
    
    //MARK: Static properites to represent unique options in the OptionSet
    
    static let None = CollisionConfiguration()
    static let Player = CollisionConfiguration(rawValue: 1 << 0)                //1
    static let Barrier = CollisionConfiguration(rawValue: 1 << 1)               //2
    static let CollidingEnemy = CollisionConfiguration(rawValue: 1 << 2)                 //4
    static let Collectible = CollisionConfiguration(rawValue: 1 << 3)           //8
        //Collectibles include hearts, coins, and jetpacks, which can be distinguish using nodename
    static let NonCollidingEnemy = CollisionConfiguration(rawValue: 1 << 4)     //16
        //Noncolliding enemies may cause damage to the player but will not necessarily induce a physic-based collision upon contact
    static let Other = CollisionConfiguration(rawValue: 1 << 5)      //32
        //Other might include portals, which register contact with the player but which do not result in collisions
    
    init(){
        rawValue = 0 << 0
    }
    
    init(rawValue: UInt32){
        self.rawValue = rawValue
    }
    
    //MARK: SpriteKit physics properites are all computed properties based on the rawValue for a given CollisionConfiguration as well as the pre-configured defined collisions and defined contact notifications
    
    var categoryMask: UInt32{
        return rawValue
    }
    
    var collisionMask: UInt32{
        var mask = CollisionConfiguration.definedCollisions[self]?.map({ $0.rawValue }).reduce(0){ return $0 | $1}
        
        return mask ?? 0
         
    }
    
    var contactMask: UInt32{
        var mask = CollisionConfiguration.definedContactNotifications[self]?.map({ $0.rawValue}).reduce(0){ return $0 | $1}
        
        return mask ?? 0
    }
    
    
}


//MARK: Static properties for collider type

extension CollisionConfiguration{
    
    //MARK: PhysicsBody Collision Dict - This dictionary maps an array of collider types for a given collider type, specifying all of the other collider types with which a given collider type can have a collision
    static var definedContactNotifications: [CollisionConfiguration:[CollisionConfiguration]] = [
        CollisionConfiguration.Player : [CollisionConfiguration.Barrier, CollisionConfiguration.CollidingEnemy, CollisionConfiguration.NonCollidingEnemy, CollisionConfiguration.Collectible, CollisionConfiguration.Other],
        CollisionConfiguration.Other : [CollisionConfiguration.Player],
        
        //These settings are tentative and subject to modificaiton
        CollisionConfiguration.CollidingEnemy : [CollisionConfiguration.Player],
        CollisionConfiguration.NonCollidingEnemy : [CollisionConfiguration.Player],
        CollisionConfiguration.Collectible : [CollisionConfiguration.Player],
        CollisionConfiguration.Barrier : [CollisionConfiguration.Player, CollisionConfiguration.CollidingEnemy]
       
    ]
    
    
    //MARK: PhysicsBody Contact Dict - This dictionary maps an array of collider types for a given collider type, specifying all of the other collider types with which a given collider type can have a collision
    static var definedCollisions: [CollisionConfiguration:[CollisionConfiguration]] = [
        CollisionConfiguration.Player : [CollisionConfiguration.Barrier, CollisionConfiguration.CollidingEnemy],
        CollisionConfiguration.Barrier : [CollisionConfiguration.Player,        CollisionConfiguration.CollidingEnemy],
        CollisionConfiguration.CollidingEnemy : [CollisionConfiguration.Player, CollisionConfiguration.Barrier,CollisionConfiguration.CollidingEnemy],
        CollisionConfiguration.Collectible : [CollisionConfiguration.None],
        CollisionConfiguration.NonCollidingEnemy : [CollisionConfiguration.None],
        CollisionConfiguration.Other : [CollisionConfiguration.None]
        
    
    ]
    
    
    
}


//MARK: Hashable Protocol conformance

extension CollisionConfiguration: Hashable{
    
    //MARK: Hashable conformance (conformance to hashable protocol allows collider type to be used as a key for a dictionary)
    
    var hashValue: Int{
        return Int(rawValue)
    }
    
    
}

//MARK: Equatable Protocol conformance (OptionSet protocol allows custom types to perform set operations like union, intersection, etc., and is suitable for bitmask types, such as Physics Collision/Contact/Category bitmasks

extension CollisionConfiguration: Equatable{
    static func ==(left: CollisionConfiguration, right: CollisionConfiguration) -> Bool{
        return (left.rawValue == right.rawValue)
    }
    
    static func !=(left: CollisionConfiguration, right: CollisionConfiguration) -> Bool{
        return !(left == right)
    }
    
}
