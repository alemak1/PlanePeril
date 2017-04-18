//
//  BackgroundObjectManager.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class BackgroundObjectManager{
    
    let bgSceneNames: [String] = [
        "bgEncounter1",
        "bgEncounter2",
        "bgEncounter3",
        "bgEncounter4"
    ]
    
    var currentEncounterIndex: Int?
    var previousEncounterIndex: Int?
    
    var encounters: [SKNode] = []
    
    //MARK: *********** Initializer
    
    init(){
        for bgSceneName in bgSceneNames{
            let bgNode = SKNode()
            
            if let bgScene = SKScene(fileNamed: bgSceneName){
                
                for placeHolderNode in bgScene.children{
                    if let node = placeHolderNode as? SKSpriteNode{
                        
                        var bgNodeFromScene: SKSpriteNode = SKSpriteNode()
                        
                        switch(node.name!){
                            case "Cloud1":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud1, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Cloud2":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud2, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Cloud3":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud3, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Cloud4":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud4, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Cloud5":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud5, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Cloud6":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud6, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Cloud7":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud7, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Cloud8":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud8, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Cloud9":
                                bgNodeFromScene = Cloud(cloudCategory: .cloud9, position: node.position, scalingAdjustmentFactor: 0.70)
                                break
                            case "Sun" :
                                bgNodeFromScene = Sun(position: node.position, scalingFactor: nil)
                                break
                            case "HalfMoon" :
                                bgNodeFromScene = Moon(position: node.position, isHalfMoon: true, scalingFactor: 0.70)
                                break
                            case "FullMoon" :
                                bgNodeFromScene = Moon(position: node.position, isHalfMoon: true, scalingFactor: 0.70)
                                break
                            default:
                                print("No node class exists for node with name:\(node.name)")
                                break
                        }
                        
                        bgNode.addChild(bgNodeFromScene)
                    }
                }
                
               
            }
            
            encounters.append(bgNode)
            saveSpritePositions(node: bgNode)
        }
    }
    
    
    //MARK: ********* Function called for placing random encounter in front of the enemy
    
    func placeEncounter(currentXPos: CGFloat){
        
        let bgEncounterCount = UInt32(encounters.count)
        
        //Exit if less than 3 encounters are available
        
        if (bgEncounterCount < 3) { return }
        
        //Pick a random encounter that is neither the current encounter nor the previous encounter 
        
        var nextEncounterIndex: Int?
        var trulyNew: Bool?
        
        while trulyNew == false || trulyNew == nil{
            
            nextEncounterIndex = Int(arc4random_uniform(bgEncounterCount))
            
            trulyNew = true
            
            if let currentIndex = currentEncounterIndex{
                if currentIndex ==  nextEncounterIndex{
                    trulyNew = false
                }
            }
            
            if let previousIndex = previousEncounterIndex{
                if previousIndex == nextEncounterIndex{
                    trulyNew = false
                }
            }
            
          
        }
        
        previousEncounterIndex = currentEncounterIndex
        currentEncounterIndex = nextEncounterIndex
        
        let encounter = encounters[currentEncounterIndex!]
        encounter.position = CGPoint(x: currentXPos + 1000, y: 0)
        resetSpritePositions(node: encounter)
        
    }
    
    //MARK: *********** Function called in the GameScene to add encounters to the world
    
    func addEncountersToWorld(world: SKNode){
        for index in 0..<encounters.count-1{
            encounters[index].position = CGPoint(x: -2000, y: index*1000)
            encounters[index].zPosition = -9
            world.addChild(encounters[index])
        }
    }
    
    //MARK: ******** Helper Functions (for saving the initial positions of the spawned background objects in their respective userData dictionaries so that they can be reset to their original positiosn and therefore recycled)
    
    func saveSpritePositions(node: SKNode){
        
        for subNode in node.children{
            if let subNode = subNode as? SKSpriteNode{
                let initialPosition = NSValue(cgPoint: subNode.position)
                subNode.userData = NSMutableDictionary()
                subNode.userData?.setValue(initialPosition, forKey: "initialPosition")
                saveSpritePositions(node: subNode)
            }
        }
    }
    
    func resetSpritePositions(node: SKNode){
        for subNode in node.children{
            if let subNode = subNode  as? SKSpriteNode{
                subNode.physicsBody?.velocity = CGVector.zero
                subNode.physicsBody?.angularVelocity = 0.00
                subNode.zRotation = 0.00
                
                if let initialPositionVal = subNode.userData?.value(forKey: "initialPosition") as? NSValue{
                    subNode.position = initialPositionVal.cgPointValue
                }
                
                resetSpritePositions(node: subNode)

                
            }
        }
    }
}
