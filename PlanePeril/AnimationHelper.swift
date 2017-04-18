//
//  AnimationHelper.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


protocol Enemy : class{
    var badKarma: Int { get set}
}

/** This class still needs testing
 
 
 **/
class AnimationHelper{
    
    func combineActions(actions: [SKAction]) -> SKAction{
        return actions.reduce(SKAction()){ action1, action2 in
            SKAction.sequence([action1,action2])
            
        }
    }
    
    func delayActionComponentsBy(delayTime: TimeInterval, actionSequence: [SKAction]) -> [SKAction]{
        
        return actionSequence.map({SKAction.group([SKAction.wait(forDuration: delayTime) ,$0])})
    }
    
    func colorizeOnScreenEnemies(withColor color: UIColor, withBlendFactor blendFactor: CGFloat, andWithDuration duration: TimeInterval, forScene scene: SKScene){
        scene.children.filter({$0 as? SKSpriteNode != nil && $0 as? Enemy != nil}).map({
            $0.run(SKAction.colorize(with: color, colorBlendFactor: blendFactor, duration: duration))
        })
    }
    
    
    func getTotalOnScreenEnemies(scene: SKScene) -> Int{
        return scene.children.filter({($0 as? SKSpriteNode) != nil && $0 as? Enemy != nil}).count
    }
    
  
    
    
    
}
