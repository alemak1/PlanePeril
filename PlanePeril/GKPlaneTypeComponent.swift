//
//  GKPlaneTypeComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class GKPlaneTypeComponent: GKComponent{
    
    enum PlaneType{
        case Red,Blue,Green,Yellow
    }
    
    var planeType: PlaneType
    
    init(planeType: PlaneType) {
        self.planeType = planeType

        super.init()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getDefaultTexture() -> SKTexture{
        switch(planeType){
        case .Blue:
            return SKTexture(image: #imageLiteral(resourceName: "planeBlue1"))
        case .Red:
            return SKTexture(image: #imageLiteral(resourceName: "planeRed1"))
        case .Yellow:
            return SKTexture(image: #imageLiteral(resourceName: "planeYellow1"))
        case .Green:
            return SKTexture(image: #imageLiteral(resourceName: "planeGreen1"))
        }
    }
    
    func getDefaultAnimation() -> SKAction{
        var defaultAction: SKAction
        
        switch(planeType){
        case .Blue:
            defaultAction = SKAction.animate(with: [
                SKTexture(image: #imageLiteral(resourceName: "planeBlue1")),
                SKTexture(image: #imageLiteral(resourceName: "planeBlue2")),
                SKTexture(image: #imageLiteral(resourceName: "planeBlue3"))
                ], timePerFrame: 0.10)
            break
        case .Red:
            defaultAction = SKAction.animate(with: [
                SKTexture(image: #imageLiteral(resourceName: "planeRed1")),
                SKTexture(image: #imageLiteral(resourceName: "planeRed2")),
                SKTexture(image: #imageLiteral(resourceName: "planeRed3"))
                ], timePerFrame: 0.10)
            break
        case .Yellow:
            defaultAction = SKAction.animate(with: [
                SKTexture(image: #imageLiteral(resourceName: "planeYellow1")),
                SKTexture(image: #imageLiteral(resourceName: "planeYellow2")),
                SKTexture(image: #imageLiteral(resourceName: "planeYellow3"))
                ], timePerFrame: 0.10)
            break
        case .Green:
            defaultAction = SKAction.animate(with: [
                SKTexture(image: #imageLiteral(resourceName: "planeGreen1")),
                SKTexture(image: #imageLiteral(resourceName: "planeGreen2")),
                SKTexture(image: #imageLiteral(resourceName: "planeGreen3"))
                ], timePerFrame: 0.10)
            break
        default:
            defaultAction = SKAction.animate(with: [
                SKTexture(image: #imageLiteral(resourceName: "planeRed1")),
                SKTexture(image: #imageLiteral(resourceName: "planeRed2")),
                SKTexture(image: #imageLiteral(resourceName: "planeRed3"))
                ], timePerFrame: 0.10)
            break
        }
        
        return defaultAction
    }
    
}
