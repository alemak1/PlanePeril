//
//  ForegroundObjectManager.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/17/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit




class ForegroundObjectManager{
    
    var sceneNames: [String] = [
        "fgEncounter1",
        "fgEncounter2",
        "fgEncounter3",
        "fgEncounter4"
    ]
    
    var encounters: [SKNode] = []
    
    var currentEncounterIndex: Int?
    var previousEncounterIndex: Int?
    
    init(parentScene: SKScene){
    
        for sceneName in sceneNames{
            
            let fgNode = SKNode()
            
            if let foreGroundScene = SKScene(fileNamed: sceneName){
                
                if let view = foreGroundScene.view{
                    let scale = UIScreen.main.bounds.size.height/view.frame.size.height
                    foreGroundScene.setScale(scale)

                }
                
                
                for node in foreGroundScene.children{
                    
                    var objectNode: SKNode = SKNode()
                    
                        if let nodeName = node.name{
                    
                            if nodeName.contains("tree"){
                                guard let treeCategory = Tree.TreeCategory(rawValue: nodeName) else {
                                    print("A tree of that category does not exist")
                                    return
                                }
                                objectNode = Tree(treeCategory: treeCategory, position: node.position, scalingFactor: 0.60)
                                
                            } else if nodeName.contains("grass"){
                                guard let grassCategory = Grass.GrassCategory(rawValue: nodeName) else {
                                    print("A grass sprite of that category does not exist")
                                    return
                                }
                                objectNode = Grass(grassCategory: grassCategory, position: node.position, scalingFactor: 0.60)
                            
                            } else if nodeName.contains("house"){
                                guard let houseCategory = House.HouseCategory(rawValue: nodeName) else {
                                    print("A house sprite of that category does not exist")
                                    return
                                }
                                objectNode = House(houseCategory: houseCategory, position: node.position, scalingFactor: 0.60)
                                
                            } else if nodeName.contains("tower"){
                                guard let towerCategory = Building.BuildingCategory(rawValue: nodeName) else {
                                    print("A tower sprite of that category does not exist")
                                    return
                                }
                                objectNode = Building(buildingCategory: towerCategory, position: node.position, scalingFactor: 0.60)
                                
                            } else if nodeName.contains("piramid"){
                                guard let piramidCategory = Building.BuildingCategory(rawValue: nodeName) else {
                                    print("A piramid of that category does not exist")
                                    return
                                }
                                objectNode = Building(buildingCategory: piramidCategory, position: node.position, scalingFactor: 0.60)
                            } else if nodeName.contains("temple"){
                                guard let templeCategory = Building.BuildingCategory(rawValue: nodeName) else {
                                    print("A temple of that category does not exist")
                                    return
                                }
                                objectNode = Building(buildingCategory: templeCategory, position: node.position, scalingFactor: 0.60)
                            }
                    
                    }
                    
                
                    fgNode.addChild(objectNode)
                }
            
            }
            
            encounters.append(fgNode)
            saveSpriteInfo(node: fgNode)
        }
    }
    
    
    //MARK: ************* Helper method for adding all the foreground encouters to the world node
    
    func addForegroundEncounters(toNode node: SKNode){
        
        for index in 0..<(encounters.count-1){
            
            let encounter = encounters[index]
            encounter.position = CGPoint(x: -2000, y: CGFloat(index)*1000)
            node.addChild(encounter)
        }
    }
    
    
    func placeForegroundEncounter(atPosition foregroundEncounterPosition: CGFloat){
        
        let numberOfEncounters = UInt32(encounters.count)
        
        if numberOfEncounters < 3 { return }
        
        var trulyNew: Bool?
        
        if trulyNew == nil || trulyNew == false{
            
            let nextEncounterIndex = Int(arc4random_uniform(numberOfEncounters))
            
            if let currentEncounterIndex = currentEncounterIndex, currentEncounterIndex == nextEncounterIndex{
                
                trulyNew = false
            }
            
            if let previousEncounterIndex = previousEncounterIndex, previousEncounterIndex == nextEncounterIndex{
                
                trulyNew == false
            }
            
            previousEncounterIndex = currentEncounterIndex
            currentEncounterIndex = nextEncounterIndex
            
            if let currentEncounterIndex = currentEncounterIndex{
                 let spawnedEncounter = encounters[currentEncounterIndex]
                spawnedEncounter.position = CGPoint(x: foregroundEncounterPosition + 1000, y: 0)
                resetSprite(node: spawnedEncounter)
                
            }
        
            
        }
    }
    
    //MARK: *************** Helper methods for storing and retrieving node data from userDict
    
    func saveSpriteInfo(node: SKNode){
        
        for node in node.children{
            if let node = node as? SKSpriteNode{
                
                let initialPosition = NSValue(cgPoint: node.position)
                
                node.userData = NSMutableDictionary()
                node.userData?.setValue(initialPosition, forKey: "initialPosition")
                
                saveSpriteInfo(node: node)
            }
        }
    }
    
    func resetSprite(node: SKNode){
        for node in node.children{
            if let node = node as? SKSpriteNode{
                
                if let initialPosition = node.userData?.value(forKey: "initialPosition") as? NSValue{
                    node.position = initialPosition.cgPointValue
                    
                }
                
                resetSprite(node: node)
                
            }
        }
    }
}
