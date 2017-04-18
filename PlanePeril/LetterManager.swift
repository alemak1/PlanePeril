//
//  LetterManager.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


class LetterManager{
    
    
    let sceneNames: [String] = [
        "letterEncounter1",
        "letterEncounter2",
        "letterEncounter3"
        ]
    
    var encounters: [SKNode] = []
    
    var currentEncounterIndex: Int?
    var previousEncounterIndex: Int?
    
    
    init(){
    
        for sceneName in sceneNames{
            
            let letterEncounterNode = SKNode()

            if let letterSceneSubnodes = SKScene(fileNamed: sceneName)?.children{
            
                
            for node in letterSceneSubnodes{
                
                if let nodeName = node.name, let letterCategory = Letter.LetterCategory(rawValue: nodeName){
                    
                        let letterNode = Letter(letter: letterCategory, position: node.position, scalingFactor: 0.70)
                        letterEncounterNode.addChild(letterNode)
                    
                    }
                
                }
            }
            
            encounters.append(letterEncounterNode)

        }
    }
    
    
    //MARK: ********** Add each letter encounter to specified node 
    
    func addLetterEncounters(node: SKNode){
        for index in 0..<encounters.count-1{
            encounters[index].position = CGPoint(x: -2000, y: CGFloat(index)*1000)
            node.addChild(encounters[index])
        }
    }
    

    
    func placeLetterEncounter(currentEncounterPos: CGFloat){
        
        let numberOfLetterEncounters = UInt32(encounters.count)
        
        if(numberOfLetterEncounters < 2) { return }
        
       
        var trulyNew: Bool?
        
        while trulyNew == nil || trulyNew == false{
            
            let nextEncounterIndex = Int(arc4random_uniform(numberOfLetterEncounters))
            
            
            trulyNew = true
            
            if let currentEncounterIndex = currentEncounterIndex{
                if currentEncounterIndex == nextEncounterIndex{
                    trulyNew = false
                }
            }
            
            if let previousEncounterIndex = previousEncounterIndex{
                if previousEncounterIndex == nextEncounterIndex{
                    trulyNew = false
                }
            }
            
            
            previousEncounterIndex = currentEncounterIndex
            currentEncounterIndex = nextEncounterIndex
            
        }
        
        if let currentEncounterIndex = currentEncounterIndex{
            let encounter = encounters[currentEncounterIndex]
            encounter.position = CGPoint(x: currentEncounterPos + 1000, y: 0)
            resetSpriteNodes(node: encounter)
        }
    }
    
    //MARK: ********* Helper Functions for saving and retrieving data for individual nodes as present in the SKS Scene files using each node's userData dict
    
    func saveSpriteNodeInfo(node: SKNode){
        
        for node in node.children{
            if let node = node as? SKSpriteNode{
                let initialPos = NSValue(cgPoint: node.position)
                node.userData = NSMutableDictionary()
                node.userData?.setValue(initialPos, forKey: "initialPos")
                saveSpriteNodeInfo(node: node)
            }
        }
        
    }
    
    func resetSpriteNodes(node: SKNode){
        for node in node.children{
            if let node = node as? SKSpriteNode{
    
                if let initialPos = node.userData?.value(forKey: "initialPos") as? NSValue{
                    node.position = initialPos.cgPointValue

                }
                
                resetSpriteNodes(node: node)
            }
        }
        
    }
    
    
    
}
