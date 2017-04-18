//
//  PPAnimationComponent.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/14/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

/**  The player animations include propeller animations,which are based on fuel level.  The propeller seems to run slower for slower speeds and faster for faster speends, depending on the fuel level.  The textures used are the same, but the elapsed time between frames is different.  
 
 Likewise, enemy characters will have different animation speeds based on game difficulty level or level number.  These usually consist of faster spinning motions or faster flapping animations.
    
    The player can also have different animations for different animations states,such as a different levels of fading or colorization. The same holds true for enemies.  These damage animations are run independently of each other, so that a high-fuel, fast player can be in low or high damage state just like a low-fuel, slow-moving player can 
 
    
    In addition to optional movement (i.e. flapping) and damage (i.e. fadeIn/fadeOut) animations, enemy character may be following a path (such a circling in a given part of the screen, moving back and forth, moving along a closed path of connected points, etc)
 
 **/



//The different animation states a character can be in; characters normally run a default animation (i.e. propeller motion, wing flapping, wheel turning) as well as additional actions that depend state (fadeOut when damaged)

enum AnimationState: String{
    
    case normal = "normal"
    case moveFast = "moveFast"
    case moveAverage = "moveAverage"
    case moveSlow = "moveSlow"
    case damageLow = "damageLow"
    case damageMedium = "damageMedium"
    case damageHigh = "damangeHigh"
    case followingPath = "followingPath"
    case attack = "attack"
    case dead = "dead"
}


//Characters can face left or right if they are asymmetrical; symmetrical character have no left or right orientation which requires adjustments be made to the texture zRotation

enum Orientation{
    case None
    case Left
    case Right
    
}


/** Consider using inheritance also; subclass Animation to get derived classes TextureAnimation and NonTextureAnimation, where Texture-Animation objects can have accessor methods for adjusting frameOffset and time interval
 **/

//A struct i.e. value-type is used in order to allow for copies with different frame offsets to be produced 

struct Animation{
    
    //Animations within a category are mutually exclusive; only one animation from a given category can be running at a given time, but animations from different categories can be running simultaneously
    enum AnimationCategory: String{
        case Movement = "movementAnimation"
        case Damage = "damageAnimation"
        case Path = "pathAnimation"
        case Other = "otherAnimation"
    }
    
    //The animation state for this animation
    
    let animationState: AnimationState
    
    let animationCategory: AnimationCategory
    
    //Nontexture animations don't require access to the textures array
    let isTextureBased: Bool
    
    
    //The key for the animation is based on the raw value of the animation state enum
    
    var categoryKey: String{
        get{
            return animationCategory.rawValue
        }
    }
    
    

    
    //Texture animations include the move animations (i.e. default static animation) but might also include animations in the other/dead category; the frameInterval varies for texture-based animations (i.e. fast, medium, and slow propeller speed)
    
    let textureAction: SKAction?
    
    //Nontexture animations include the pathAnimations, damage animations, and path
    let nonTextureAction: SKAction?
    
    let repeatActionForever: Bool
    
  
    
    
}


class PPAnimationComponent: GKComponent{
    
    //The most recent animation state that the animation component has been requested to play
    
    var requestedAnimationState: AnimationState?
    
    
    //The node on which animations should be run for this component 
    
    var node: SKSpriteNode
    
    //The current set of animations for the component entity 
    
    var animations: [AnimationState: Animation]
    
    
    //The animation that is currently running
    
    private(set) var currentAnimation: Animation?
    
    //The length of time spent in the current animation state
    
    private var elapsedAnimationDuration: TimeInterval = 0.0
    
    //MARK: ********** Initializers
    
    init(textureSize: CGSize, animations: [AnimationState: Animation]) {
        
        node = SKSpriteNode(texture: nil, color: .clear, size: textureSize)
        
        self.animations = animations
        
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ********** GKComponent LifeCycle 
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        //If an animation has been requested, run the animation 
        
        if let animationState = requestedAnimationState{
            
            runAnimationForAnimationState(animationState: animationState, deltaTime: seconds)
            
            requestedAnimationState = nil
        }
    }
    
    
    func runAnimationForAnimationState(animationState: AnimationState, deltaTime: TimeInterval){
        
        
        //Update tracking for how long the animation has been occurring
        elapsedAnimationDuration += deltaTime
        
        //Check if the requested animation state is the same as the animation that is currently running; if so, then exit the function
        
        if currentAnimation != nil && currentAnimation!.animationState == animationState {
            return
        }
        
        
        guard let unwrappedAnimation = animations[animationState] else {
            print("Unknown animation for state \(animationState.rawValue)")
            return
        }
        
        var animation = unwrappedAnimation
        
        //Check if the animation category has changed
        
        if currentAnimation?.animationCategory != animation.animationCategory{
            
            //Remove the existing category animation
            node.removeAction(forKey: animation.categoryKey)
            
            //Reset the node's position in parent if it has been following a path animation
            node.position = CGPoint.zero
            
            var newAction: SKAction?
            
            if animation.isTextureBased, let textureAction = animation.textureAction{
                //TODO: create the texture-based action taking into account texture interval and frame offset
                newAction = textureAction
                
            } else if let nonTextureAction = animation.nonTextureAction {
                newAction = nonTextureAction
            }
            
            if let newAction = newAction{
                
                let finalAction = animation.repeatActionForever ? SKAction.repeatForever(newAction) : newAction
                
                node.run(finalAction, withKey: animation.categoryKey)

            }
            
            
        }
        
        
        currentAnimation = animation
        
        elapsedAnimationDuration = 0.0
    }
    
}
