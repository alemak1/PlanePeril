//
//  SceneB.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion


class SceneB: EnemyAgentScene{
    
    var lastUpdateTime: TimeInterval = 0.00
    var worldLoopInterval: TimeInterval = 0.00
    
    var player = GKPlayerPlane.mainPlayer
    var cameraTargetPosition: CGPoint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        entitiesManager.add(player)
        
        let enemy1 = GKChasingEnemySun(scalingFactor: 0.40, size: nil, position: nil)
        let upDownMoveComponent = enemy1.component(ofType: GKUpDownMoveComponent.self)
        upDownMoveComponent?.startWithDownMovement()
        
        let madfly1 = GKMadFly(scalingFactor: 0.40, size: nil, position: CGPoint(x: 40, y: 50))
        entitiesManager.add(madfly1)
        
        let madfly2 = GKMadFly(scalingFactor: 0.30, size: nil, position: CGPoint(x: 30, y: 20))
        
        let madfly1Agent = madfly1.component(ofType: GKFlyAgent.self)
        
        let coherencyComponent = GKCoherencyAgent(otherAgentSoughtForCohrence: madfly1Agent!)
        
        madfly2.addComponent(coherencyComponent)
        entitiesManager.add(madfly2)
        
        entitiesManager.add(enemy1)
        
        if let camera = self.camera, let playerNode = player.component(ofType: GKSpriteComponent.self)?.node{
            camera.addChild(world)
            camera.addChild(playerNode)
        }
        
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
        worldLoopInterval = dt
        
        entitiesManager.update(dt)
        
        cameraTargetPosition = player.component(ofType: GKSpriteComponent.self)?.node.position
    
        
//        if let camera = self.camera, let playerPosition = player.component(ofType: GKTransformComponent.self)?.getCurrentPosition(){
//        
//            camera.position = playerPosition
//        }
        
        /**
        if(dt > 3.00){
            world.position = CGPoint(x: world.position.x - ScreenSizeConstants.HalfScreenWidth, y: world.position.y)
            
            worldLoopInterval = 0.00
        }
        **/
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        if let playerNode = player.component(ofType: GKSpriteComponent.self)?.node{
         //  self.centerOnNode(node: playerNode)
        }
        
        
    }
    
    func centerOnNode(node: SKNode){
        
        guard let world = self.world else { return }
        
        let camerPositionInScene = self.convert(node.position, from: world)
        
        world.position = CGPoint(x: world.position.x - camerPositionInScene.x, y: world.position.y)
     
        
        
    }
}
