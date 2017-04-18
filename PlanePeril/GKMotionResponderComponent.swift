//
//  GKMotionResponderComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit
import CoreMotion


//MARK:  ********** NOT YET FULLY IMPLEMENTED 

/**  General Motion Corresponder requires an observer for changes in device orientation
 
 
**/

/**
class GKGeneralMotionResponderComponent: GKComponent{
    

    var motionManager: CMMotionManager!
    var currentOrientation: UIDeviceOrientation?
    
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
    
    
    init(motionManager: CMMotionManager){
        
        super.init()
        
        self.motionManager = motionManager
        self.resetDeviceOrientation(notification: nil)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(GKGeneralMotionResponderComponent.resetDeviceOrientation(notification:)), name: Notification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        
    }
    
    func resetDeviceOrientation(notification: NSNotification?){
        
    
        if let notification = notification, let userInfo = notification.userInfo{
            
            guard let deviceOrientationRawValue = userInfo[UIApplicationStatusBarOrientationUserInfoKey] as? Int else { return }
            
            guard let deviceOrientation = UIDeviceOrientation(rawValue: deviceOrientationRawValue) else { return }
            
            self.currentOrientation = deviceOrientation

        }
    }
    
    func setAppliedForceDeltaX(){
        
        if let motionData = motionManager.deviceMotion{
            let horizontalAttitude = motionData.attitude.roll
            let horizontalRotationRate = motionData.rotationRate.y
            
            let verticalAttitude = -motionData.attitude.pitch
            let verticalRotationRate = -motionData.rotationRate.x
            
            
            guard let currentOrientation = self.currentOrientation else { return }
            
            if(UIDeviceOrientationIsPortrait(currentOrientation)){
                if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){
                    appliedForceDeltaX = CGFloat(horizontalRotationRate)*150.00
                }
                
                
                
            }
            
            
            
            if(UIDeviceOrientationIsLandscape(currentOrientation)){
                if((verticalAttitude < 0.00 && verticalRotationRate < 0.00) || (verticalAttitude > 0.00 && verticalRotationRate > 0.00)){
                    appliedForceDeltaX = CGFloat(verticalRotationRate)*150.00
                }
                
                
                
            }
            
           
            
            
            
        }
    }
    
    
    func setAppliedForceDeltaY(){
        
        if let motionData = motionManager.deviceMotion{
            let horizontalAttitude = motionData.attitude.roll
            let horizontalRotationRate = motionData.rotationRate.y
            
            let verticalAttitude = -motionData.attitude.pitch
            let verticalRotationRate = -motionData.rotationRate.x
            
            
            guard let currentOrientation = self.currentOrientation else { return }
            
            if(UIDeviceOrientationIsPortrait(currentOrientation)){
                if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){

                }
                
            }
            
            
            if(UIDeviceOrientationIsLandscape(currentOrientation)){
                if((verticalAttitude < 0.00 && verticalRotationRate < 0.00) || (verticalAttitude > 0.00 && verticalRotationRate > 0.00)){

                }
                
            }
            
        }
    }
    
    
    func applyPhysicsBodyForceFromRotationInput(){
        let appliedImpulseVector = CGVector(dx: appliedForceDeltaX, dy: appliedForceDeltaY)
        physicsBody.applyForce(appliedImpulseVector)
        
    }
    

}

**/


class GKPortraitMotionResponderComponent: GKComponent{
    
    var motionManager: CMMotionManager!
    
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
    
    
    init(motionManager: CMMotionManager){
        super.init()
        
        self.motionManager = motionManager
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        
    }
    
    
    func setAppliedForceDeltaX(){
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable, let motionData = motionManager.deviceMotion{
            let horizontalAttitude = motionData.attitude.roll
            let horizontalRotationRate = motionData.rotationRate.y
            
            if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){
                appliedForceDeltaX = CGFloat(horizontalRotationRate)*150.00
            }
            
            
        }
    }
    
    
    func setAppliedForceDeltaY(){
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable, let motionData = motionManager.deviceMotion{
            let verticalAttitude = -motionData.attitude.pitch
            let verticalRotationRate = -motionData.rotationRate.x
            
            if((verticalAttitude < 0.00 && verticalRotationRate < 0.00) || (verticalAttitude > 0.00 && verticalRotationRate > 0.00)){
                appliedForceDeltaY = CGFloat(verticalRotationRate)*150.00
            }
            
            
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

class GKPortraitMotionResponderComponentXY: GKPortraitMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaX()
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
    
}

class GKPortraitMotionResponderComponentX: GKPortraitMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaX()
        applyPhysicsBodyForceFromRotationInput()
    }
    
}


class GKPortraitMotionResponderComponentY: GKPortraitMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
    
}

class GKLandscapeMotionResponderComponent: GKComponent{
    
    var motionManager: CMMotionManager!
    
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
    
    
    init(motionManager: CMMotionManager){
        super.init()
        
        self.motionManager = motionManager
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        
    }
    
    
    func setAppliedForceDeltaY(){
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable,let motionData = motionManager.deviceMotion{
            let horizontalAttitude = -motionData.attitude.roll
            let horizontalRotationRate = -motionData.rotationRate.y
            
            if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){
                appliedForceDeltaY = CGFloat(horizontalRotationRate)*150.00
            }
            
            
        }
    }
    
    
    func setAppliedForceDeltaX(){
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable,let motionData = motionManager.deviceMotion{
            let verticalAttitude = -motionData.attitude.pitch
            let verticalRotationRate = -motionData.rotationRate.x
            
            if((verticalAttitude < 0.00 && verticalRotationRate < 0.00) || (verticalAttitude > 0.00 && verticalRotationRate > 0.00)){
                appliedForceDeltaX = CGFloat(verticalRotationRate)*150.00
            }
            
            
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


class GKLandscapeMotionResponderComponentY: GKLandscapeMotionResponderComponent{
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
}


class GKLandscapeMotionResponderComponentX: GKLandscapeMotionResponderComponent{
    

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        setAppliedForceDeltaX()
        applyPhysicsBodyForceFromRotationInput()
    }
}


class GKLandscapeMotionResponderComponentXY: GKLandscapeMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaX()
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
}
