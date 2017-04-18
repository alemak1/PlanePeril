//
//  Cloud.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

/** Subclasses for Background Objects
 
 
 **/

class Cloud: SKSpriteNode{
    
    enum CloudCategory: String{
        case cloud1, cloud2, cloud3, cloud4, cloud5, cloud6, cloud7, cloud8, cloud9
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(cloudCategory: CloudCategory, position: CGPoint, scalingAdjustmentFactor: CGFloat?) {
        let texture = SKTexture(imageNamed: cloudCategory.rawValue)
        let textureSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: textureSize)
        self.position = position
        
        if let scalingFactor = scalingAdjustmentFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
    }
}


class Moon: SKSpriteNode{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(position: CGPoint, isHalfMoon: Bool, scalingFactor: CGFloat?) {
        
        let texture = isHalfMoon ? SKTexture(image: #imageLiteral(resourceName: "moon_half")) : SKTexture(image: #imageLiteral(resourceName: "moon_full"))
        let textureSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: textureSize)
        
        if let scalingFactor = scalingFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
    }
}


class Sun: SKSpriteNode{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(position: CGPoint, scalingFactor: CGFloat?) {
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "sun"))
        let textureSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: textureSize)
        
        self.position = position
        
        if let scalingFactor = scalingFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
    }
}
