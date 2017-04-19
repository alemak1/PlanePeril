//
//  Frog.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit



class Frog: SKSpriteNode{
    
    enum ActionState{
        case Normal
        case Jump
        case Dead
    }
    
    var currentActionState: ActionState = .Normal{
        didSet{
            if(oldValue != currentActionState){
                
                switch(currentActionState){
                    case .Normal:
                        break
                    case .Jump:
                        let jumpAction = Frog.getFrogAnimation(actionState: .Jump)
                        run(jumpAction)
                        let impulseVector = CGVector(dx: -30, dy: 40)
                        self.physicsBody?.applyForce(impulseVector)
                        break
                    case .Dead:
                        let deadAction = Frog.getFrogAnimation(actionState: .Dead)
                        run(deadAction)
                        break
                    
                }
            }
        }
    }
    
    var jumpActionDelay: TimeInterval = 5.00
    var frameCount: TimeInterval = 0.00
    var lastUpdateTime: TimeInterval = 0.00
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(position: CGPoint, scalingFactor: CGFloat?, jumpActionDelay: TimeInterval) {
        
        guard let frogTexture = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Frog)?.textureNamed("frog") else {
            
            print("Frog texture could not be located. Initialization of spikeball could not be completed")
            return nil
        }
        
        let textureSize = frogTexture.size()
        
        self.init(texture: frogTexture, color: .clear, size: textureSize)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.position = position
        self.jumpActionDelay = jumpActionDelay
        
        configurePhysicsProperties(circleSize: textureSize)
        configureDefaultAnimation()
        
        if let scalingFactor = scalingFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
        
    }
    
    private func configurePhysicsProperties(circleSize: CGSize){
        self.physicsBody = SKPhysicsBody(circleOfRadius: circleSize.width/2.0)
        
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = NGKCollisionConfiguration.NonCollidingEnemy.categoryMask
        self.physicsBody?.collisionBitMask = NGKCollisionConfiguration.NonCollidingEnemy.collisionMask
        self.physicsBody?.contactTestBitMask = NGKCollisionConfiguration.NonCollidingEnemy.categoryMask
        
    }
    
    
    func update(deltaTime seconds: Double){
        
        frameCount += seconds - lastUpdateTime
        
        if(frameCount > jumpActionDelay){
            
            currentActionState = .Jump
            
            frameCount = 0
        }
        
        lastUpdateTime = seconds
    }
    
    private func configureDefaultAnimation(){
        
        let defaultAnimation = Frog.getFrogAnimation(actionState: .Normal)
        run(defaultAnimation)
    }
    
}

extension Frog{
    
    static func getFrogAnimation(actionState: ActionState) -> SKAction{
        
        var textureName: String
        
        switch actionState {
        case .Normal:
            textureName = "frog"
            break
        case .Jump:
            textureName = "frog_move"
            break
        case .Dead:
            textureName = "frog_dead"
            break
            
        }
        
        if let texture = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Frog)?.textureNamed(textureName){
            
            let rawAction = SKAction.setTexture(texture)
            
            return rawAction
        }
        
        return SKAction()
    }
    
    
  
}
