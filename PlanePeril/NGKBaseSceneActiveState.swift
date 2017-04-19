//
//  NGKBaseSceneActiveState.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class NGKBaseSceneActiveState: GKState{
    
    unowned var levelScene: NGKBaseScene
    
    init(levelScene: NGKBaseScene) {
        self.levelScene = levelScene
    }
    
    
    //MARK: ******* GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if(levelScene.player.currentFuelState == .NoFuel){
            stateMachine?.enter(NGKBaseSceneFailState.self)
        }
        
        if(levelScene.player.currentHealthState == .Dead){
            stateMachine?.enter(NGKBaseSceneFailState.self)
        }
        
        if(levelScene.inProgressWord == levelScene.targetWord){
            stateMachine?.enter(NGKBaseSceneSuccessState.self)
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        
        switch(stateClass){
            case is NGKBaseSceneSuccessState.Type, is NGKBaseSceneFailState.Type:
                return true
            case is NGKBaseScenePauseState.Type:
                return true
            default:
                return false
        }
        
    }
}
