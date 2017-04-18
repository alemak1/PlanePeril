//
//  PPHealthComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class PPHealthComponent: GKComponent{
    
    var healthLevel: Int = 4
    
    var currentHealthLevel: Int = 4
    var previousHealthLevel: Int = 4
    
    init(startingHealthLevel: Int){
        self.healthLevel = startingHealthLevel
        self.currentHealthLevel = startingHealthLevel
        self.previousHealthLevel = startingHealthLevel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
