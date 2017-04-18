//
//  PPPlayerPlaneMediumFuelState.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class PPPlayerPlaneMediumFuelState: GKState{
    
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
    
    //MARK:  Initializer
    
    init(entity: PPPlayerPlaneEntity){
        self.entity = entity
    }
    
    //MARK: GKState LifeCycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        //Request the "move average" animation
        animationComponent.requestedAnimationState = .moveAverage
    
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        //Fuel Variables
        let currentFuel = fuelTankComponent.fuelAmount
        let thresholdLowFuel = fuelTankComponent.lowFuelThreshold
        let thresholdHighFuel = fuelTankComponent.highFuelThreshold
        
        if(currentFuel < thresholdLowFuel){
            stateMachine?.enter(PPPlayerPlaneLowFuelState.self)
        } else if(currentFuel > thresholdHighFuel){
            stateMachine?.enter(PPPlayerPlaneHighFuelState.self)
        }
        
        //Health Variables
        let currentHealth = healthComponent.healthLevel
        
        if(currentHealth != healthComponent.previousHealthLevel){
            switch(currentHealth){
            case 3:
                stateMachine?.enter(PPPlayerPlaneLowDamageState.self)
                break
            case 2:
                stateMachine?.enter(PPPlayerPlaneMediumDamageState.self)
                break
            case 1:
                stateMachine?.enter(PPPlayerPlaneHighDamageState.self)
                break
            case 0:
                stateMachine?.enter(PPPlayerPlaneDeadState.self)
            default:
                stateMachine?.enter(PPPlayerPlaneNormalFlyingState.self)
            }
            
            healthComponent.previousHealthLevel = currentHealth
        }

    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch(stateClass){
        case is PPPlayerPlaneLowFuelState.Type,is PPPlayerPlaneHighFuelState.Type:
            return true
        case is PPPlayerPlaneDeadState.Type:
            return true
        case is PPPlayerPlaneLowDamageState.Type, is PPPlayerPlaneMediumDamageState.Type, is PPPlayerPlaneHighDamageState.Type:
            return true
        case is PPPlayerPlaneNormalFlyingState.Type:
            return true
        default:
            return false
        }
    }
    
    
}
