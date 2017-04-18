//
//  GKMotionResponderComponentAsynchronous.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import CoreMotion

class GKAsynchronousLandscapeMotionResponderComponent: GKComponent{
    
    var coreMotionHelper = CoreMotionHelper.sharedHelper
    
    var rotationRateX: Double?
    var rotationRateY: Double?
    var rotationRateZ: Double?
    
    var pitch: Double?
    var roll: Double?
    var yaw: Double?
    
    /** The physicsBody is a computed property, which means that is assumed that (1) the MotionResponder component has already been added to an entity, and (2) the entity to which it has been added already has physics component that can be accessed indirectly via the entity property of the component; this component is tightly coupled to the physics component, and its functionality is added as a component for readability and semantic consistency
     
     
     **/
    var physicsBody: SKPhysicsBody{
        get{
            if let parentEntity = self.entity, let physicsComponent = parentEntity.component(ofType: GKPhysicsBodyComponent.self){
                return physicsComponent.parentPhysicsBody!
            }
            
            return SKPhysicsBody()
        }
    }
    
    var appliedForceDeltaX: CGFloat = 0.00
    var appliedForceDeltaY: CGFloat = 0.00
    
    
    override init(){
        
        super.init()
        
        getRotationData()
        getDeviceMotionData()

    }
    
    private func getRotationData(){
        coreMotionHelper.getGyroData(interval: 0.50, closure:
        {
        
            (pitch: Double, roll: Double, yaw: Double) in
        
            self.pitch = pitch
            self.roll = roll
            self.yaw = yaw
            
        })
        
    }
    
    
    private func getDeviceMotionData(){
        coreMotionHelper.getGyroData(interval: 0.50, closure: {
        
            (xRotationRate: Double, yRotationRate: Double, zRotationRate: Double) in
            
            self.rotationRateX = xRotationRate
            self.rotationRateY = yRotationRate
            self.rotationRateZ = zRotationRate
        
        })
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        getDeviceMotionData()
        getRotationData()
        
    }
    
    
    func setAppliedForceDeltaY(){
        
        
        guard let roll = self.roll, let rotationRateY = self.rotationRateY else {
            print("Data not yet available for roll and rotationRateY")
            return
        }
        
            let horizontalAttitude = -roll
            let horizontalRotationRate = -rotationRateY
            
            if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){
                appliedForceDeltaY = CGFloat(horizontalRotationRate)*150.00
            }
            
            
        
    }
    
    
    func setAppliedForceDeltaX(){
        
        guard let pitch = self.pitch, let rotationRateX = self.rotationRateX else {
            print("Data not yet available for pitch and rotationRateX")
            return
        }
        
        let verticalAttitude = -pitch
        let verticalRotationRate = -rotationRateX
            
            if((verticalAttitude < 0.00 && verticalRotationRate < 0.00) || (verticalAttitude > 0.00 && verticalRotationRate > 0.00)){
                appliedForceDeltaX = CGFloat(verticalRotationRate)*150.00
            }
            
            
        
    }
    
    
    
    
    
    
    func applyPhysicsBodyForceFromRotationInput(){
        let appliedImpulseVector = CGVector(dx: appliedForceDeltaX, dy: appliedForceDeltaY)
        physicsBody.applyForce(appliedImpulseVector)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet")
    }
}


class GKAsynchronousLandscapeMotionResponderComponentY: GKAsynchronousLandscapeMotionResponderComponent{
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
}


class GKAsynchronousLandscapeMotionResponderComponentX: GKAsynchronousLandscapeMotionResponderComponent{
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        setAppliedForceDeltaX()
        applyPhysicsBodyForceFromRotationInput()
    }
}


class GKAsynchronousLandscapeMotionResponderComponentXY: GKAsynchronousLandscapeMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaX()
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
}
