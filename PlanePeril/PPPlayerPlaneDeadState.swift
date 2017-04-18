//
//  PPPlayerPlaneDeadState.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class PPPlayerPlaneDeadState: GKState{
    
    
    unowned var entity: PPPlayerPlaneEntity
    
    
    
    //MARK: the "Fuel Tank Component" associated with the entity
    
    var fuelTankComponent: PPFuelTankComponent{
        guard let fuelTankComponent = entity.component(ofType: PPFuelTankComponent.self) else {
            fatalError("A player plane must have a fuel tank component")
        }
        
        return fuelTankComponent
    }
    
    
    //MARK: the "Health component" associated with the entity
    var healthComponent: PPHealthComponent{
        guard let healthComponent = entity.component(ofType: PPHealthComponent.self) else {
            fatalError("A player plane must have a health component")
        }
        
        return healthComponent
    }
    
    
    //MARK: the "Animation Component" associated with the entity
    
    var animationComponent: PPAnimationComponent{
        guard let animationComponent = entity.component(ofType: PPAnimationComponent.self) else { fatalError("A player plane must have an animation component") }
        
        return animationComponent
    }
    
    
    
    
    //MARK: Initializers
    
    init(entity: PPPlayerPlaneEntity) {
        self.entity = entity
    }
    
    //MARK: GKLifeCylce
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        //Request the "dead" animation
        animationComponent.requestedAnimationState = .dead
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        

        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
       return false
    }
    
}
