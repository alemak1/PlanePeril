//
//  Background.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class NGKBackground: SKSpriteNode{
    
    
    //0 is full adjustment (no movement as the world goes past), 1 is no adjustment (background passes at normal speed)
    var movementMultiplier = CGFloat(0)
    
    //Stores how many points the backgrounds has jumped forward
    var jumpAdjustment = CGFloat(0)
    
    //Constant for background size (bounds of the device size is used)
    var backgroundSize = UIScreen.main.bounds.size
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(sksFileName: String, zPosition: CGFloat, movementMultiplier: CGFloat) {
        
        self.init(texture: nil, color: .clear, size: UIScreen.main.bounds.size)
        
        configureNode(sksFileName: sksFileName, zPosition: zPosition, movementMultiplier: movementMultiplier)
        
    }
    
    func configureNode(sksFileName: String, zPosition: CGFloat, movementMultiplier: CGFloat){
        //Backgrounds are positioned from the bottom left
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //Backgrounds are positioned slightly above the ground
        self.position = CGPoint(x: 0.00, y: 0.00)
        
        //Each background is configured with its own multiplier and zPosition
        self.zPosition = zPosition
        self.movementMultiplier = movementMultiplier
        
        let scene = SKScene(fileNamed: sksFileName)
        
        for i in -1...1{
            let newBGNode = scene?.childNode(withName: "RootNode") as? SKSpriteNode
            newBGNode?.anchorPoint = CGPoint.zero
            newBGNode?.size = self.backgroundSize
            newBGNode?.zPosition = zPosition
            newBGNode?.position = CGPoint(x: i*Int(backgroundSize.width), y: 0)
            newBGNode?.move(toParent: self)
        }
    }
    
    func updatePosition(playerProgress: CGFloat){
        
        let adjustedPosition = jumpAdjustment + playerProgress*(1-movementMultiplier)
        
        if (playerProgress - adjustedPosition > backgroundSize.width){
            jumpAdjustment += backgroundSize.width
            self.position.x = adjustedPosition
        }
    }
    
}
