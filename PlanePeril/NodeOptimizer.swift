//
//  NodeOptimizer.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class NodeOptimizer{
    
    /** Remove nodes taht are outside the bounds of the screen
 
    **/
    func removeOutOfBoundNodes(scene: SKScene){
        scene.children.filter({ ($0 as? SKSpriteNode) != nil})
            .filter({
                ($0.position.x < -ScreenSizeConstants.HalfScreenWidth) &&
                    ($0.position.x > ScreenSizeConstants.HalfScreenWidth) &&
                    ($0.position.y > ScreenSizeConstants.HalfScreenHeight) &&
                    ($0.position.y < ScreenSizeConstants.HalfScreenHeight)
            })
            .map({ $0.removeFromParent() })
        
    }
    

}
