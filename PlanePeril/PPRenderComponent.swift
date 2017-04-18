//
//  PPRenderComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class RenderComponent: GKComponent{
    
    //MARK: Properties
    
    let node = SKNode()
    
    //MARK: GKComponent method (i.e. parent methods)
    
    override func didAddToEntity() {
        node.entity = entity
    }
    
    override func willRemoveFromEntity() {
        node.entity = nil
    }
}
