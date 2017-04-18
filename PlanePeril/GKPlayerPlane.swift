//
//  GKPlayerPlane.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion

class GKPlayerPlane: GKEntity{
    

    static let mainPlayer = GKPlayerPlane(planeType: .Blue, scalingFactor: 0.40, motionManager: MainMotionManager.sharedMotionManager , position: CGPoint(x: -ScreenSizeConstants.HalfScreenWidth*0.80, y: 0), size: nil)
    
    private var isUserPlayer: Bool = true
    
    init(planeType: GKPlaneTypeComponent.PlaneType, scalingFactor: CGFloat, motionManager: CMMotionManager, position: CGPoint?, size: CGSize?, physicsBody: SKPhysicsBody? = SKPhysicsBody(), isUserPlayer: Bool = true){
        super.init()
        
        //Add GKPlaneTypeComponent 
        addPlaneTypeComponent(planeType: planeType)
        
        guard let planeTypeComponent = self.component(ofType: GKPlaneTypeComponent.self) else { return }
        
        let defaultTexture = planeTypeComponent.getDefaultTexture()
        let defaultAnimation = planeTypeComponent.getDefaultAnimation()
        
        //Add GKSpriteComponent
        addSpriteComponent(texture: defaultTexture, scalingFactor: scalingFactor)
        
        //Add GKTransformComponent
        let playerPosition = position ?? CGPoint.zero
        addTransformComponent(position: playerPosition, size: size)
        
        //Add GKPhysicsComponent (default component is independent of parent's entity GKSpriteNode component)
        addPhysicsComponent(physicsBody: nil)
        
        //Add GKMotionResponderComponent
        addMotionResponderComponent(motionManager: motionManager, hasHeightConstraints: false)
        
        /** TODO: Still need to test the implementation that uses the CMHandler for updates that are handled on an operation queue passed in as an argument
         
        addAsynchronousMotionResponderComponent()
        **/
       
        //Add the propeller animation for the flying plane
        addAnimationComponent(defaultAction: defaultAnimation)
        
        //Add agent component to the plain in order to allow enemy objects to identify and pursue the player
        addAgentComponent()
        
        //Set the GKPlayer as the userPlayer (for multiplayer games, non-user players may be present in the scene)
        self.isUserPlayer = isUserPlayer
        
    }
    
    func playerIsCurrentUser() -> Bool{
        return self.isUserPlayer
    }
    
    func addPlaneTypeComponent(planeType: GKPlaneTypeComponent.PlaneType){
        
        var planeTypeComponent: GKPlaneTypeComponent
        
        switch(planeType){
        case .Yellow:
            planeTypeComponent = GKPlaneTypeComponent(planeType: .Yellow)
            break
        case .Blue:
            planeTypeComponent = GKPlaneTypeComponent(planeType: .Blue)
            break
        case .Green:
            planeTypeComponent = GKPlaneTypeComponent(planeType: .Green)
            break
        case .Red:
            planeTypeComponent = GKPlaneTypeComponent(planeType: .Red)
            break
        }
        
        addComponent(planeTypeComponent)
    }

    
    func addSpriteComponent(texture: SKTexture, scalingFactor: CGFloat){
        let spriteComponent = GKSpriteComponent(texture: texture)
        
        spriteComponent.node.xScale *= scalingFactor
        spriteComponent.node.yScale *= scalingFactor
        
        addComponent(spriteComponent)
    }
    
    /** The first size used is that provided by the user; if that is unavailable, then the size defaults to the SpriteComponent node's texture size; if that is unavailable, then the size defaults ot a hard-coded value
     **/
    func addTransformComponent(position: CGPoint?, size: CGSize?){
        
        let textureSize = component(ofType: GKSpriteComponent.self)?.node.size
        let defaultSize: CGSize? = textureSize ?? CGSize(width: 40, height: 40)
        
        let playerPosition = position ?? CGPoint.zero
        let playerSize = size ?? defaultSize
        
        let transformComponent = GKTransformComponent(position: playerPosition, size: playerSize)
        addComponent(transformComponent)
        transformComponent.setTransformPropertiesForParent()
        
    }
    
    /** If the GKSpriteComponent has been added, then the PhysicsBody will be based on the SpriteComponent's texture only; if it has not been added, then the physics body component will default to the user-provided physics body, which may be null
     
     **/
    private func addPhysicsComponent(physicsBody: SKPhysicsBody?){
        
        
        let physicsComponent: GKPhysicsBodyComponent = GKPhysicsBodyComponent(defaultPhysicsBody: physicsBody)
        addComponent(physicsComponent)
        
        if(physicsBody != nil){
            physicsComponent.setParentPhysicsBodyToDefault()
        }
        
        //Couple the GKPhysicsBodyComponent with the GKSpriteNodeComponent of the parent
        
        if let texture = component(ofType: GKPlaneTypeComponent.self)?.getDefaultTexture(){
            
            let textureSize = texture.size()
            
            physicsComponent.setPhysicsBodyForParent(physicsBodyType: .Texture, circleRadius: nil, edgePoint1: nil, edgePoint2: nil, path: nil, rectSize: nil, rectCenter: nil, circleCenter: nil, texture: texture, textureSize: textureSize)
            physicsComponent.setPhysicsPropertiesFor(physicsBodyCategory: .Parent)
        }
        
        physicsComponent.parentPhysicsBody?.categoryBitMask = PhysicsCategory.Player.rawValue
        physicsComponent.parentPhysicsBody?.collisionBitMask = PhysicsCategory.Barrier.rawValue
        physicsComponent.parentPhysicsBody?.contactTestBitMask = PhysicsCategory.Enemy.rawValue | PhysicsCategory.Barrier.rawValue

        physicsComponent.parentPhysicsBody?.velocity = CGVector(dx: 50.0, dy: 0.0)
        physicsComponent.parentPhysicsBody?.linearDamping = 0.00
        
        
    }
    
    
    private func addAnimationComponent(defaultAction: SKAction){
        //TODO: Refactor this function so that TextureManager and AnimationFactory is used
        
     
        let animationComponent = GKAnimationComponent(defaultAnimation: defaultAction, animationName: "propellerAnimation")
        addComponent(animationComponent)
        animationComponent.runDefaultAnimation()

        
    }
    
    private func addMotionResponderComponent(motionManager: CMMotionManager, hasHeightConstraints: Bool){
    
        
        let motionResponderComponent = GKLandscapeMotionResponderComponentY(motionManager: motionManager)
       
        addComponent(motionResponderComponent)
    
        
    }
    
    private func addAsynchronousMotionResponderComponent(){
        
        let motionResponderComponent = GKAsynchronousLandscapeMotionResponderComponentY()
        
        addComponent(motionResponderComponent)
    }
    
    private func addAgentComponent(){
        let agentComponent = GKAgent2D()
        addComponent(agentComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
