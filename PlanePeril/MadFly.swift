//
//  MadFly.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MadFly: SKSpriteNode{
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init?(position: CGPoint, scalingFactor: CGFloat?) {
        
        guard let flyTexture = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .EnemySun)?.textureNamed("flyFly1") else {
            
            print("MadFly texture could not be located. Initialization of spikeball could not be completed")
            return nil
        }
        
        let textureSize = flyTexture.size()
        
        self.init(texture: flyTexture, color: .clear, size: textureSize)
        
        self.position = position
        
        configurePhysicsProperties(circleSize: textureSize)
        configureDefaultAnimation()
        
        if let scalingFactor = scalingFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
        
    }
    
    private func configurePhysicsProperties(circleSize: CGSize){
        self.physicsBody = SKPhysicsBody(circleOfRadius: circleSize.width/2.0)
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        self.physicsBody?.categoryBitMask = NGKCollisionConfiguration.Enemy.categoryMask
        self.physicsBody?.collisionBitMask = NGKCollisionConfiguration.Enemy.collisionMask
        self.physicsBody?.contactTestBitMask = NGKCollisionConfiguration.Enemy.categoryMask
        
    }
    
    private func configureDefaultAnimation(){
        
        let defaultAnimation = MadFly.getDefaultAnimation(isRepeatingForever: true)
        run(defaultAnimation)
    }
    
}

extension MadFly{
    static func getDefaultAnimation(isRepeatingForever: Bool) -> SKAction{
        
        if let texture1 = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .OtherEnemies)?.textureNamed("flyFly1"), let texture2 = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .OtherEnemies)?.textureNamed("flyFly2"){
            
            let rawAction = SKAction.animate(with: [ texture1, texture2], timePerFrame: 0.10)
            
            let finalAction = isRepeatingForever ? SKAction.repeatForever(rawAction) : rawAction
            
            return finalAction
            
            
        }
        
        return SKAction()
        
    }
}
