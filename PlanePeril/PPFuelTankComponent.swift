//
//  PPFuelTankComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class PPFuelTankComponent: GKComponent{
    
    var fuelAmount: Double = 100.00
    
    var fuelConsumptionRate: Double = 1.00
    
    var lowFuelThreshold: Double = 20.00
    var highFuelThreshold: Double = 90.00
    
    
    private var flightTime: Double = 0.00
    private var lastUpdatedFlightTime: Double = 0.00
    
    
    init(initialFuelAmount: Double, fuelConsumptionRate: Double, lowFuelThreshold: Double, highFuelThreshold: Double) {
        
        self.fuelAmount = initialFuelAmount
        self.fuelConsumptionRate = fuelConsumptionRate
        self.lowFuelThreshold = lowFuelThreshold
        self.highFuelThreshold = highFuelThreshold
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let elapsedFlightTime = seconds - lastUpdatedFlightTime
        
        
        //If the parent entity is a player plane that is currently invulnerable, then fuel consumption is suspended
        if let entity = entity as? PPPlayerPlaneEntity, !entity.isVulnerable{
            return
        }
        
        
        fuelAmount -= elapsedFlightTime*fuelConsumptionRate
        
        lastUpdatedFlightTime = seconds
    }
}
