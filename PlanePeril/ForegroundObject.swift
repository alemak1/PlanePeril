//
//  ForegroundObject.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit

//MARK: *************** TREE

class Tree: SKSpriteNode{
    
    
    enum TreeCategory: String{
        case tree01, tree02, tree03, tree04, tree05, tree06, tree07, tree08, tree09, tree10
        case tree11, tree12, tree13, tree14, tree15, tree16, tree17, tree18, tree19, tree20
        case tree21, tree22, tree23, tree24, tree25, tree26, tree27, tree28, tree29, tree30
            
        var texture: SKTexture{
            get{
                return SKTexture(imageNamed: self.rawValue)
            }
        }
    }
        
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(treeCategory: TreeCategory, position: CGPoint, scalingFactor: CGFloat?){
        
        let texture = treeCategory.texture
        let textureSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: textureSize)
        
        if let scalingFactor = scalingFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
    }
}


//MARK:************ GRASS

class Grass: SKSpriteNode{
    
    
    enum GrassCategory: String{
        case grass1, grass2, grass3, grass4, grass5, grass6
        
        var texture: SKTexture{
            get{
                return SKTexture(imageNamed: self.rawValue)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(grassCategory: GrassCategory, position: CGPoint, scalingFactor: CGFloat?) {
        
        let texture = grassCategory.texture
        let textureSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: textureSize)
        
        if let scalingFactor = scalingFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
        
    }
}

//MARK:************ HOUSE

class House: SKSpriteNode{
    
    enum HouseCategory: String{
        case house_grey_side, house_grey_front, house_beige_side, house_beige_front
        
        var texture: SKTexture{
            get{
                return SKTexture(imageNamed: self.rawValue)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(houseCategory: HouseCategory, position: CGPoint, scalingFactor: CGFloat?) {
        
        let texture = houseCategory.texture
        let textureSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: textureSize)
        
        if let scalingFactor = scalingFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
        
    }
}

//MARK:*******************  BUILDING

class Building: SKSpriteNode{
    
    enum BuildingCategory: String{
        case piramid, temple, tower_grey, tower_beige
        
        var texture: SKTexture{
            get{
                return SKTexture(imageNamed: self.rawValue)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(buildingCategory: BuildingCategory, position: CGPoint, scalingFactor: CGFloat?) {
        
        let texture = buildingCategory.texture
        let textureSize = texture.size()
        
        self.init(texture: texture, color: .clear, size: textureSize)
        
        if let scalingFactor = scalingFactor{
            self.xScale *= scalingFactor
            self.yScale *= scalingFactor
        }
        
    }
}
