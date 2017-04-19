//
//  NGKBaseSceneFailState.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class NGKBaseSceneFailState: GKState{
    
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
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        
        switch(stateClass){
            default:
                return false
        }
        
    }

    
}
