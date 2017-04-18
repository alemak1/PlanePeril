//
//  PPIntelligenceComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class PPIntelligenceComponent: GKComponent{
    
    //MARK: Properties
    
    let stateMachine: GKStateMachine
    
    let initalStateClass: AnyClass
    
    //MARK: Initializers
    
    init(states: [GKState]){
        stateMachine = GKStateMachine(states: states)
        
        let firstState = states.first!
        
        initalStateClass = type(of: firstState)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        stateMachine.update(deltaTime: seconds)
    }
    
    func enterInitialState(){
        stateMachine.enter(initalStateClass)
    }
}
