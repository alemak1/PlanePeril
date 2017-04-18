//
//  GKCoherencyAgent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/13/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit


class GKCoherencyAgent: GKAgent2D{
    
    var agentBehavior: GKBehavior!
    
    init(otherAgentSoughtForCohrence: GKAgent2D) {
        super.init()
        
        let agentGoal = GKGoal(toCohereWith: [otherAgentSoughtForCohrence], maxDistance: 10.0, maxAngle: Float(2.00*M_PI))
        agentBehavior = GKBehavior(goal: agentGoal, weight: 1.00)
        self.behavior = agentBehavior
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
