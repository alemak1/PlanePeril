//
//  EnemyAgentScene.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/12/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion


class EnemyAgentScene: SKScene{
    
    //Flag indicating whether we've setup the camera or not
    var isCreated: Bool = false
    
    //Add game characters (players, enemies, items, etc.) to the world
    var world: SKNode!
    
    //Background image is fixed like the overlay, except it's zPosition is further back
    var backgroundNode: SKSpriteNode!
    
    //Add UI elements to the overlay
    var overlay: SKNode!
    
  
    
    var entitiesManager: EntityManager!
    //var motionManager: CMMotionManager = MainMotionManager.mainMotionManager
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
      
      
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        //Perform basic scene configuration
        backgroundColor = ColorGenerator.getColor(colorType: .SkyBlue)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        if !isCreated{
            isCreated = true
            
            //Set the anchor point to the center of the screen
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            //Add the world node
            world = SKNode()
            world.position = CGPoint.zero
            world.zPosition = 15
            world.name = "world"
            self.addChild(world)
            
            let scene = SKScene(fileNamed: "Background.sks")
            let rootNode = scene?.childNode(withName: "RootNode")
            rootNode?.move(toParent: world!)
            
            //Initialize the camera and add it to the world node
            self.camera = SKCameraNode()
            if let camera = self.camera{
                self.addChild(camera)
                camera.addChild(world)
            }
            
            //Add the overlay for holding UI elements
            overlay = SKNode()
            overlay.zPosition = 30
            overlay.name = "overlay"
            self.addChild(overlay!)
            
            
        }
        
        //Initialize entities manager
        entitiesManager = EntityManager(scene: self)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
     
        /**
        let worldTopLeft = self.convert(ScreenPoints.TopLeftCorner, to: world)
        let worldTopRight = self.convert(ScreenPoints.TopRightCorner, to: world)
        let worldBottomLeft = self.convert(ScreenPoints.BottomLeftCorner, to: world)
        let worldBottomRight = self.convert(ScreenPoints.BottomRightCorner, to: world)
        **/
        
//        let topBarrierNode = SKNode()
//        topBarrierNode.physicsBody = SKPhysicsBody(edgeFrom: worldTopLeft, to: worldTopRight)
//        topBarrierNode.physicsBody?.categoryBitMask = PhysicsCategory.Barrier.rawValue
//        topBarrierNode.name = "topBarrier"
//        self.addChild(topBarrierNode)
//        
//        let bottomBarrierNode = SKNode()
//        bottomBarrierNode.physicsBody = SKPhysicsBody(edgeFrom: worldBottomLeft, to: worldBottomRight)
//        bottomBarrierNode.physicsBody?.categoryBitMask = PhysicsCategory.Barrier.rawValue
//        bottomBarrierNode.name = "bottomBarrier"
//        self.addChild(bottomBarrierNode)
//        
        
      //  let topEdgeRect = CGRect(x: -ScreenSizeConstants.HalfScreenWidth, y: ScreenSizeConstants.ScreenHeight*1.5, width: ScreenSizeConstants.ScreenWidth, height: ScreenSizeConstants.ScreenHeight)
        //let topEdgeBarrier = SKPhysicsBody(edgeLoopFrom: topEdgeRect)
        //topEdgeBarrier.affectedByGravity = false
        //topEdgeBarrier.isDynamic = false
        
        //let bottomEdgeBarrier = SKPhysicsBody(edgeFrom: ScreenPoints.BottomLeftCorner, to: ScreenPoints.BottomRightCorner)
        //bottomEdgeBarrier.affectedByGravity = false
        //bottomEdgeBarrier.isDynamic = false
        //world.physicsBody = SKPhysicsBody(bodies: [
            //topEdgeBarrier
            //bottomEdgeBarrier
          //  ])
       //world.physicsBody?.affectedByGravity = false
       //world.physicsBody?.isDynamic = false
        
      /**
        backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode.zPosition = -15
        backgroundNode.scale(to: UIScreen.main.bounds.size)
        let rockyBottomPositionInBackground = self.convert(CGPoint(x: 0.0, y: -ScreenSizeConstants.HalfScreenHeight), to: backgroundNode)
        let rockyTopPositionInBackground = self.convert(CGPoint(x: 0.0,y: ScreenSizeConstants.HalfScreenHeight), to: backgroundNode)
        backgroundNode.position = CGPoint.zero

        let rockyTop = SKSpriteNode(imageNamed: "groundDirt")
        
         **/
        /**
        let rockyTopTexture = SKTexture(image: #imageLiteral(resourceName: "groundDirt"))
        let rockyTopSize = rockyTopTexture.size()
        
        rockyTop.physicsBody = SKPhysicsBody(rectangleOf: rockyTopSize)
        rockyTop.physicsBody?.affectedByGravity = false
        rockyTop.physicsBody?.isDynamic = false 
         **/
        
        /**
        rockyTop.anchorPoint = CGPoint(x: 0.5, y: 0)
        rockyTop.run(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0.0))
        rockyTop.position = rockyTopPositionInBackground
        backgroundNode.addChild(rockyTop)
        
        let rockyBottom = SKSpriteNode(imageNamed: "groundDirt")
        rockyBottom.anchorPoint = CGPoint(x: 0.5, y: 0)
        rockyBottom.position = rockyBottomPositionInBackground
        backgroundNode.addChild(rockyBottom)
        world.addChild(backgroundNode)
        **/
   
        
        /**
        let edgeWidth = ScreenSizeConstants.ScreenWidth
        let edgeHeight = ScreenSizeConstants.ScreenHeight
        let edgeRect = CGRect(x: -ScreenSizeConstants.HalfScreenWidth, y: -ScreenSizeConstants.HalfScreenHeight, width: edgeWidth, height: edgeHeight)
        **/
        
        
    
     
        
        
    }
    
    override func didSimulatePhysics() {
     
    }
    
   
}
