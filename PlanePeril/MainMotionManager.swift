//
//  MainMotionManager.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import CoreMotion

class MainMotionManager: CMMotionManager{
    
    static let sharedMotionManager = MainMotionManager()
    
    override init(){
        super.init()
    }
}
