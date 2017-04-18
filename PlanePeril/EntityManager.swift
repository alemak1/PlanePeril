//
//  EntityManager.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation

import Foundation
import GameplayKit
import SpriteKit

class EntityManager{
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    
    let scene: EnemyAgentScene
    
    lazy var componentSystems: [GKComponentSystem] = {
        let motionResponderXYSystem = GKComponentSystem(componentClass: GKLandscapeMotionResponderComponentXY.self)
        let motionResponderYSystem = GKComponentSystem(componentClass: GKLandscapeMotionResponderComponentY.self)
        let motionResponderXSystem = GKComponentSystem(componentClass: GKLandscapeMotionResponderComponentX.self)
        let upDownMoveComponent = GKComponentSystem(componentClass: GKUpDownMoveComponent.self)
        
       let agentComponent = GKComponentSystem(componentClass: GKAgent2D.self)
        
        return [motionResponderXYSystem, motionResponderXSystem, motionResponderYSystem, agentComponent, upDownMoveComponent]
    }()
    
    
    init(scene: EnemyAgentScene){
        self.scene = scene
    }
    
    
    func update(_ deltaTime: CFTimeInterval){
        for componentSystem in componentSystems{
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for currentRemove in toRemove{
            for componentSystem in componentSystems{
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        
        toRemove.removeAll()
    }
    
    func add(_ entity: GKEntity){
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: GKSpriteComponent.self)?.node{
            scene.world?.addChild(spriteNode)
        }
        
        for componentSystem in componentSystems{
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    func remove(_ entity: GKEntity){
        if let spriteNode = entity.component(ofType: GKSpriteComponent.self)?.node{
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func getGKPlayerEntities() -> [GKPlayer]{
        return self.entities.flatMap{entity in
            
            if let entity = entity as? GKPlayer{
                return entity
            }
            
            return nil
        }
    }
    
    func getCurrentUserPlayer() -> GKPlayer?{
        
        let players = getGKPlayerEntities()
        
        for player in players{
            if player.playerIsCurrentUser(){
                return player
            }
        }
        
        return nil
    }
    
    func getGKEnemyEntities() -> [GKEnemy]{
        return self.entities.flatMap{ entity in
            
            if let entity = entity as? GKEnemy{
                return entity
            }
            
            return nil
        }
    }
}
