//
//  LetterLabel.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class LetterLabel{
    
    enum Alignment{
        case Left, Center, Right
    }
    
    var word: String
    var letterSpacing: Double
    var alignment: Alignment
    var letterScaleFactor: CGFloat = 1.0
    
    var letterNodeArray: [SKSpriteNode]{
        get{
            var letterSpriteArray = [SKSpriteNode]()
            
            for char in word.characters{
                let letterType = Letter.LetterCategory(character: char)
                let texture = letterType.texture
                
                let letterNode = SKSpriteNode(texture: texture)
                letterSpriteArray.append(letterNode)
                
            }
            
            return letterSpriteArray
            
        }
    }
    
    
    init(word: String, letterSpacing: Double, alignment: Alignment, letterScaleFactor: CGFloat = 1.0){
        
        self.word = word
        self.letterSpacing = letterSpacing
        self.alignment = alignment
        self.letterScaleFactor = letterScaleFactor
        
       
    }
    
    
    func getAlignedLabel(color: UIColor, size: CGSize) -> SKSpriteNode{
        let labelNode = getRawLabel()
        
        
        switch(alignment){
            case .Center:
                labelNode.anchorPoint = CGPoint(x: 0.5, y: 0)
                break
            case .Left:
                labelNode.anchorPoint = CGPoint(x: 0.00, y: 0.00)
                break
            case .Right:
                labelNode.anchorPoint = CGPoint(x: 1, y: 0.00)
                break
            default:
                labelNode.anchorPoint = CGPoint(x: 0.5, y: 0.00)
        }
        
        let containingLabel = SKSpriteNode(color: color, size: size)
        containingLabel.addChild(labelNode)
        labelNode.position = CGPoint.zero
        
        for letterNode in labelNode.children{
            if let node = letterNode as? SKSpriteNode{
                let transformedPosition = containingLabel.convert(node.position, from: labelNode)
                node.move(toParent: containingLabel)
                node.position = transformedPosition
            }
        }
        
        labelNode.removeFromParent()
        
        return containingLabel
        
    }
    
    func getRawLabel() -> SKSpriteNode{
        
        let wordSprite = SKSpriteNode()
     //   wordSprite.size = CGSize(width: 200, height: 100)
        
        var previousLetterEndpoint: Double = 0
        
        let standardWidth = letterNodeArray[0].size.width
        
        for index in 0..<letterNodeArray.count{
            
            var currentLetterWidth = Double(letterNodeArray[index].size.width)
        
            var xPos = previousLetterEndpoint
            
            previousLetterEndpoint += currentLetterWidth + letterSpacing
            
            print("The xPos for letter \(index + 1) is \(xPos)")
            let letterNode = letterNodeArray[index]
           // letterNode.anchorPoint = CGPoint(x: 0.00, y: 0.00)
            
            letterNode.position = CGPoint(x: xPos, y: 0.00)
            wordSprite.addChild(letterNode)

        }
       
        return wordSprite
    }
    
    func applyUniformLetterScaling(scalingFactor: CGFloat?){
        
        let scaleFactor = scalingFactor ?? self.letterScaleFactor
        
        letterNodeArray.map({
            $0.xScale = scaleFactor
            $0.yScale = scaleFactor
        })
    }
    
    func applyScalingForLetters(scalingFactor: CGFloat, ordinalLetterLocations: Int...){
        
        for ordinalNumber in ordinalLetterLocations{
            letterNodeArray[ordinalNumber].xScale *= scalingFactor
            letterNodeArray[ordinalNumber].yScale *= scalingFactor
            
        }
    }
}
