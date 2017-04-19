//
//  Player.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class Player: SKSpriteNode{
    
    
    //MARK: Color of the current player instance

    var currentColor: Color = .Blue

    
    //MARK: Fuel level and fuel state for the current player instance
   
    var currentFuelLevel: Double = 100
    var fuelConsumptionRate: Double = 1000
    
    var currentFuelState: FuelState = .HighFuel{
        willSet{
            if(newValue == currentFuelState){
                return
            } else {
                if action(forKey: Player.TextureAnimationKey) != nil{
                    removeAction(forKey: Player.TextureAnimationKey)
                }
            }
        }
        
        didSet{
            if(oldValue == currentFuelState){
                return
            }
            else {
               
                if let currentTextureBasedAnimation = currentTextureBasedAnimation{
                    let newAnimation = SKAction.repeatForever(currentTextureBasedAnimation)
                    run(newAnimation, withKey: Player.TextureAnimationKey)
                }
                
               
            }
        }
    }
    
    
    
    //MARK: Health-Level and Health-State for the current plane instance
  
    var currentHealthLevel: Int = 4
    
    var currentHealthState: HealthState = .Normal{
        willSet{
            
            if(newValue == currentHealthState) {
                return
            }
            else {
                
                //If an animation is running for a previous health state, remove the old health state animation before replacing it with a new one
                
                if action(forKey: Player.NonTextureAnimationKey) != nil{
                    removeAction(forKey: Player.NonTextureAnimationKey)

                }
                
            }
        }
        
        didSet{
            if(oldValue != currentHealthState){
                if let currentNonTextureBasedAnimation = currentNonTextureBasedAnimation{
                    //currentNonTextureBasedAnimation = animationForNewHealthState
                    let finalAnimation = SKAction.repeatForever(currentNonTextureBasedAnimation)
                    run(finalAnimation, withKey: Player.NonTextureAnimationKey)

                }
                
              
            }
        }
    }
    
    //MARK: ****** Current Texture-based and NonTexture-based animations are computed properties that are based on the currentFuelState and currentHealthState, respectively.  These animations will change in respond to the property observers that adjust the fuel state and health state, respectively... Initial texture and non-texture animations are set at initializations (if necessary)

    var currentTextureBasedAnimation: SKAction?{
        get{
            return Player.TextureAnimationsDict[currentColor]?[currentFuelState]
        }
        
        set(newTextureBasedAnimation){
            if let newAnimation = newTextureBasedAnimation{
                currentTextureBasedAnimation = newAnimation
            }
        }
    }
    
    var currentNonTextureBasedAnimation: SKAction?{
        get{
            return Player.NonTextureAnimationsDict[currentHealthState]

        }
        
        set(newNonTextureBasedAnimation){
            if let newAnimation = newNonTextureBasedAnimation{
                currentNonTextureBasedAnimation = newAnimation
            }
        }
    }
    
    
    //MARK: ******** Initial position of the player (set at initialization)
    var playerStartXPos: Double = 0.00
    
    
    //MARK: ****** Total distance traveled by the player as determined from initial position and current position
    
    var playerProgress: Double{
        get{
            return Double(position.x) - playerStartXPos
        }
    }
    
    //MARK: ******* Applied Force (dY) is determined dynamically at run-time based on gyroscope data input
    
    var appliedForceDeltaY: CGFloat = 0.00
    
    var normalForwardVelocity: Double = 100.0
  
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        super.init(texture: texture, color: color, size: size)

    }
    
    
    convenience init?(color: Color, playerStartXPos: Double, normalForwardVelocity: CGFloat) {
        
        
        var playerTexture: SKTexture?
        
        switch color {
        case .Blue:
            playerTexture = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Planes)?.textureNamed("planeBlue1")
            break
        case .Green:
            playerTexture = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Planes)?.textureNamed("planeGreen1")
            break
        case .Yellow:
            playerTexture = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Planes)?.textureNamed("planeYellow1")
            break
        case .Red:
            playerTexture = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Planes)?.textureNamed("planeRed1")
            break
        default:
            playerTexture = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Planes)?.textureNamed("planeBlue1")
            break
        }
        
        guard let initializedPlayerTexture = playerTexture else {
            print("Plane texture could not be loaded or could not be found")
            return nil
        }
        
        let textureSize = initializedPlayerTexture.size()
        
        self.init(texture: initializedPlayerTexture, color: .clear, size: textureSize)
        
        print("Initializing the physics properties for the the plane...")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
      
        //Set initial health and fuel states to normal and high, respectively
        self.currentHealthState = .Normal
        self.currentFuelState = .HighFuel
        
        self.currentFuelLevel = 100
        self.currentHealthLevel = 4
        
        //Set initial player position
        self.playerStartXPos = playerStartXPos
        self.position = CGPoint(x: playerStartXPos, y: 0.00)
        
        //Set normalForwardVelocity
        self.normalForwardVelocity = Double(normalForwardVelocity)
        
        //Set default physics properites 
        configureDefaultPhysicsBody(physicsBodyTexture: initializedPlayerTexture, physicsBodySize: textureSize, normalForwardVelocity: normalForwardVelocity)
        
        
        //Animation for initial fuel and health state must be set directly in the initializer since the property observer (state change event handler) is not executed during initialization
        
        print("Setting the initial animation for the player...")
        if let animationForInitialFuelState = Player.TextureAnimationsDict[color]?[FuelState.HighFuel]{
            let finalAnimation = SKAction.repeatForever(animationForInitialFuelState)
            run(finalAnimation, withKey: Player.TextureAnimationKey)
        }
        
    }
    
    
    private func configureDefaultPhysicsBody(physicsBodyTexture: SKTexture, physicsBodySize: CGSize, normalForwardVelocity: CGFloat){
        
        self.physicsBody = SKPhysicsBody(texture: physicsBodyTexture, size: physicsBodySize)
        
        //Set default properites 
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        
        //Set category, collision, and contact bitmasks
        
        self.physicsBody?.collisionBitMask = NGKCollisionConfiguration.Player.collisionMask
        self.physicsBody?.categoryBitMask = NGKCollisionConfiguration.Player.categoryMask
        self.physicsBody?.contactTestBitMask = NGKCollisionConfiguration.Player.contactMask
        
        //Set linear and angular velocity properties
        self.physicsBody?.linearDamping = 0.00
        self.physicsBody?.velocity.dx = normalForwardVelocity
        
        
        
        
    }
    
    func getMotionInput(motionManager: CMMotionManager){
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable,let motionData = motionManager.deviceMotion{
            let horizontalAttitude = -motionData.attitude.roll
            let horizontalRotationRate = -motionData.rotationRate.y
            
            
            if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){
                appliedForceDeltaY = CGFloat(horizontalRotationRate)*150.00
                
                let isAboveScreen = appliedForceDeltaY > 0 && self.position.y > ScreenSizeConstants.HalfScreenHeight
                
                let isBelowScreen = appliedForceDeltaY < 0 && self.position.y < -ScreenSizeConstants.HalfScreenHeight
                
                if(isAboveScreen || isBelowScreen) { appliedForceDeltaY = 0 }
                
                self.physicsBody?.velocity.dy = appliedForceDeltaY
                self.physicsBody?.velocity.dx = CGFloat(normalForwardVelocity)
            }
            
            
        }
    }
    
    
    func update(deltaTime: TimeInterval){
        
        //Update fuel level and fuel state
      
        currentFuelLevel -= deltaTime*fuelConsumptionRate
        
        
        if(currentFuelLevel < 30){
            currentFuelState = .LowFuel
        } else if(currentFuelLevel < 80){
            currentFuelState = .MediumFuel
        } else {
            currentFuelState = .HighFuel
        }
        
        
        //Update health state
        
        switch(currentHealthLevel){
            case 4:
                currentHealthState = .Normal
            case 3:
                currentHealthState = .LowDamage
            case 2:
                currentHealthState = .MediumDamage
            case 1:
                currentHealthState = .HighDamage
            default:
                currentHealthState = .Normal
        }
    }
    
    
    func takeDamage(){
        currentHealthLevel -= 1
    }
    
    
}


//MARK: ********** Player Class Nested Type (for defining Player State)

extension Player{
    
    //MARK: ******** Plane Color
    
    enum Color{
        case Blue, Yellow, Red, Green
        
    }
    
  
    //MARK: Fuel State variables
    enum FuelState{
        case LowFuel, MediumFuel, HighFuel, NoFuel
    }
    

    //MARK: Health State variables
    enum HealthState{
        case Normal, LowDamage, MediumDamage, HighDamage, Dead
    }
    
    
}

//MARK: *********** Player Animations Dictionary (player animations dictionary is constant across all instances of the player class and not just true of an individual player)

extension Player{
    
    //MARK: Fuel State Animations Dictionary
    static let TextureAnimationKey: String = "currentTextureAnimation"
    static let NonTextureAnimationKey: String = "nonTextureAnimation"
    
    static var TextureAnimationsDict = [Color:[FuelState: SKAction]]()
    static var NonTextureAnimationsDict = [HealthState: SKAction]()
    
    //MARK: ************* Configuration For Plane Animations Dictionaries (texture-based and non-texture based animations), which map different health and fuel states to different animations
    
    static func ConfigurePlaneAnimations(){
        
        
        Player.TextureAnimationsDict = [
            
            Color.Blue : [
                FuelState.HighFuel: getPlaneAnimation(textureName1: "planeBlue1", textureName2: "planeBlue2", textureName3: "planeBlue3", perFrameTimeInterval: 0.10),
                FuelState.MediumFuel:  getPlaneAnimation(textureName1: "planeBlue1", textureName2: "planeBlue2", textureName3: "planeBlue3", perFrameTimeInterval: 0.25),
                FuelState.LowFuel:  getPlaneAnimation(textureName1: "planeBlue1", textureName2: "planeBlue2", textureName3: "planeBlue3", perFrameTimeInterval: 0.50) ],
            
            
            
            Color.Green : [
                
                FuelState.HighFuel:  getPlaneAnimation(textureName1: "planeGreen1", textureName2: "planeGreen2", textureName3: "planeGreen3", perFrameTimeInterval: 0.10),
                FuelState.MediumFuel:  getPlaneAnimation(textureName1: "planeGreen1", textureName2: "planeGreen2", textureName3: "planeGreen3", perFrameTimeInterval: 0.25),
                FuelState.LowFuel:  getPlaneAnimation(textureName1: "planeGreen1", textureName2: "planeGreen2", textureName3: "planeGreen3", perFrameTimeInterval: 0.50) ],
            
            Color.Red : [
                
                FuelState.HighFuel:  getPlaneAnimation(textureName1: "planeRed1", textureName2: "planeRed2", textureName3: "planeRed3", perFrameTimeInterval: 0.10),
                FuelState.MediumFuel:  getPlaneAnimation(textureName1: "planeRed1", textureName2: "planeRed2", textureName3: "planeRed3", perFrameTimeInterval: 0.25),
                FuelState.LowFuel:  getPlaneAnimation(textureName1: "planeRed1", textureName2: "planeRed2", textureName3: "planeRed3", perFrameTimeInterval: 0.50) ],
            
            Color.Yellow: [
                
                FuelState.HighFuel: getPlaneAnimation(textureName1: "planeYellow1", textureName2: "planeYellow2", textureName3: "planeYellow3", perFrameTimeInterval: 0.10),
                FuelState.MediumFuel: getPlaneAnimation(textureName1: "planeYellow1", textureName2: "planeYellow2", textureName3: "planeYellow3", perFrameTimeInterval: 0.25),
                FuelState.LowFuel: getPlaneAnimation(textureName1: "planeYellow1", textureName2: "planeYellow2", textureName3: "planeYellow3", perFrameTimeInterval: 0.50)
                
            ]
            
        ]
        
        Player.NonTextureAnimationsDict = [
            
            HealthState.LowDamage : SKAction.sequence([
                SKAction.fadeAlpha(to: 0.80, duration: 0.10),
                SKAction.fadeAlpha(to: 1.00, duration: 0.10)
                ]),
            
            HealthState.MediumDamage : SKAction.sequence([
                SKAction.fadeAlpha(to: 0.50, duration: 0.10),
                SKAction.fadeAlpha(to: 0.80, duration: 0.10)
                ]),
            
            HealthState.HighDamage : SKAction.sequence([
                SKAction.fadeAlpha(to: 0.30, duration: 0.10),
                SKAction.fadeAlpha(to: 0.60, duration: 0.10)
                ])
            
        ]
    }
    
    //Helper Function for configuring plane animations of different colors
    
    static private func getPlaneAnimation(textureName1: String, textureName2: String, textureName3: String, perFrameTimeInterval: Double) -> SKAction{
        
        guard let texture1 = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Planes)?.textureNamed(textureName1), let texture2 = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Planes)?.textureNamed(textureName2), let texture3 = TextureAtlasManager.sharedInstance.getTextureAtlas(atlasType: .Planes)?.textureNamed(textureName3) else { return SKAction() }
        
        let flightAction = SKAction.animate(with: [
            texture1,
            texture2,
            texture3
            ], timePerFrame: perFrameTimeInterval)
        
        return flightAction
        
    }
    

    
}
