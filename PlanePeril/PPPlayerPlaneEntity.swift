//
//  PPPlayerPlaneEntity.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PPPlayerPlaneEntity: GKEntity{
    
    var isVulnerable: Bool = false
    
    
    //MARK: Initializers
    
    override init(){
        
        super.init()
        
        //MARK: Add Render Component
        
        
        //MARK: Add Physics Component
        
        
        //MARK: Add Animation Component
        
        
        //MARK: Add Health Component
        
        
        //MARK: Add Motion Responder Component
        
        
        //MARK: Add FuelTank Component
        
        
        //MARK: Add Agent Component (to allow for enemies to chase enemy when in attack mode)
        
        //MARK: Add Intelligence Component
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
