//
//  NGKBaseScene.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion
import MapKit

class NGKPhysicsCategory{
    static let Player: UInt32 = 0b1 << 0
    static let Letter: UInt32 = 0b1 << 1
    static let Enemy: UInt32 =  0b1 << 2
    static let Barrier: UInt32 = 0b1 << 3
    static let Collectible: UInt32 = 0b1 << 4
    static let NoncollidingEnemy: UInt32 = 0b1 << 5
    static let Portal: UInt32 = 0b1 << 6
    
}

class NGKBaseScene: SKScene, SKPhysicsContactDelegate{
    
    
    //MARK: Timer-Related Variables 
    var lastUpdatedTime: TimeInterval = 0.00
    
    //MARK: Foreground, Background, and Enemy Managers
    let bgObjectManager = BackgroundObjectManager()
    var nextBgEncounterSpawnPosition = CGFloat(100)
    
    var fgObjectManager: ForegroundObjectManager!
    var nextFgEncounterSpawnPosition = CGFloat(100)
    
    let letterManager = LetterManager()
    var nextLetterEncounterSpawnPosition = CGFloat(100)
    
    //MARK: Scene Nodes
    var world: SKNode!
    
    var playerProgress: CGFloat = 0.00
    var player: Player!
    var playerStartXPos: CGFloat = 0.00
    
    var jumpWidth = UIScreen.main.bounds.width
    var jumpCount = CGFloat(1)
    var movingBackground: SKSpriteNode!
    
    
    var staticBackground: SKSpriteNode!
    
    var madFly: SKSpriteNode!
    
    
    //MARK: ******** Main Map View
    var mapView = MKMapView()
    
    //MARK: ******** MotionManger 
    
    var motionManager = MainMotionManager.sharedMotionManager
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //Configure the plane animations dictionary before instantiating the first player
        Player.ConfigurePlaneAnimations()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        if let view = self.view{
            let locationCoordinate = CLLocationCoordinate2D(latitude: 25.033499866, longitude: 121.558997764)
            let locationSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            
            mapView.region = MKCoordinateRegion(center: locationCoordinate, span: locationSpan)
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
       mapView.alpha = 0.40
        
        NSLayoutConstraint.activate([
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.90)
            ])
            
            
            /**
            let imageView = SKView()
            mapView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.50),
                imageView.heightAnchor.constraint(equalTo: mapView.heightAnchor, multiplier: 0.50)
                ])
            
            **/
            
        }
        
        configureWorld()
        
        player = Player(color: .Blue, playerStartXPos: Double(playerStartXPos), normalForwardVelocity: 100)
        
        
        world.addChild(player)
        
       
        /**
        let madFlyTexture = SKTexture(image: #imageLiteral(resourceName: "flyFly2"))
        let flyTextureSize = madFlyTexture.size()
        
        madFly = SKSpriteNode(texture: madFlyTexture)
        madFly.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        madFly.position = CGPoint(x: 60, y: 60)
        madFly.physicsBody = SKPhysicsBody(texture: madFlyTexture, size: flyTextureSize)
        madFly.physicsBody?.affectedByGravity = false
        madFly.physicsBody?.collisionBitMask = NGKPhysicsCategory.Player
        madFly.physicsBody?.categoryBitMask = NGKPhysicsCategory.Enemy | NGKPhysicsCategory.Barrier
        madFly.physicsBody?.contactTestBitMask = 0
        madFly.physicsBody?.velocity.dx = -100
        
        self.addChild(madFly)
        **/
        
        //Spawn the parallax backgrounds in the backgrounds array
       /**
        let grassBackground = NGKBackground(sksFileName: "Background4", zPosition: -1, movementMultiplier: 0.4).childNode(withName: "RootNode")
        
        grassBackground?.setScale(scale*0.60)
        grassBackground?.position = CGPoint(x: 0.00, y: -UIScreen.main.bounds.size.height*0.20)

        grassBackground?.move(toParent: self)
        **/
        
     
        configureStaticBackground()
        configureMovingBackground()
        
     
  
        fgObjectManager = ForegroundObjectManager(parentScene: self)
        bgObjectManager.addEncountersToWorld(world: world)
        fgObjectManager.addForegroundEncounters(toNode: world)
        letterManager.addLetterEncounters(node: world)
        
        let letterA = Letter(letter: .letterA, position: CGPoint(x: 100, y: 0), scalingFactor: 0.70)
        let letterB = Letter(letter: .letterB, position: CGPoint(x: 200, y: 0), scalingFactor: 0.70)
        
        world.addChild(letterA)
        world.addChild(letterB)
        
        self.physicsWorld.contactDelegate = self
        
        /**
        let letterLabel = LetterLabel(word: "pqrstuvwxyz", letterSpacing: 5.0, alignment: .Left)
        let letterLabelSprite = letterLabel.getRawLabel()
        letterLabelSprite.anchorPoint = CGPoint(x: 0.00, y: 0.00)
        letterLabelSprite.position = CGPoint(x: -ScreenSizeConstants.HalfScreenWidth*0.90, y: 0)
        addChild(letterLabelSprite)
         **/
        
    }
    
    private func configureWorld(){
        world = SKNode()
        addChild(world)
    }
    
  
    
    private func configureStaticBackground(){
        let scale = UIScreen.main.bounds.height/view!.frame.size.height
        
        staticBackground = SKScene(fileNamed: "Background5")?.childNode(withName: "RootNode") as? SKSpriteNode
        staticBackground?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        staticBackground?.position = CGPoint.zero
        staticBackground?.setScale(scale)
        staticBackground?.zPosition = -10
        
        staticBackground.move(toParent: self)
        
        
        
    }
    
    private func configureMovingBackground(){
        let scale = UIScreen.main.bounds.height/view!.frame.size.height

        movingBackground = SKSpriteNode()
        movingBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        movingBackground.position = CGPoint.zero
        movingBackground.zPosition = -8
        movingBackground.move(toParent: world)
        
        for i in -1...1{
            
            let bgNode = SKScene(fileNamed: "Background1")?.childNode(withName: "RootNode") as? SKSpriteNode
            
            bgNode?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bgNode?.position = CGPoint(x: CGFloat(i)*(jumpWidth), y: -ScreenSizeConstants.HalfScreenHeight*0.60)
            bgNode?.setScale(scale*0.6)
            bgNode?.move(toParent: movingBackground)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdatedTime == 0) {
            self.lastUpdatedTime = currentTime
        }
        
        super.update(currentTime)
        
        let dt = currentTime - lastUpdatedTime
        lastUpdatedTime = currentTime
        
        playerProgress = player.position.x - playerStartXPos
        
        player.update(deltaTime: dt)
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable,let motionData = motionManager.deviceMotion{
            let horizontalAttitude = -motionData.attitude.roll
            let horizontalRotationRate = -motionData.rotationRate.y
            
           print("The horizontal attitude is \(horizontalAttitude), and the horizontal rotation rate is \(horizontalRotationRate)")
            
            if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){
                let currentCenterCoordinate = mapView.centerCoordinate
                
                let adjustedLatitude = currentCenterCoordinate.latitude + horizontalRotationRate/100000
                let adjustedLongitutde = currentCenterCoordinate.longitude
                
                mapView.centerCoordinate = CLLocationCoordinate2D(latitude: adjustedLatitude, longitude: adjustedLongitutde)
            }
            
          
            
            
        }
       
        
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        //Center the world node on the player
        centerOnNode(node: player)
        
        //Apply impulse to player based on input from gyroscope data
        player.getMotionInput(motionManager: motionManager)

        //Loop the SkyCastle background so that it continually stays in step with the plaer
        updateMovingBackground(playerProgress: playerProgress)
        
        updateLetterEncounterPositions()
        updateBackgroundObjectEncounters()
        updateForegroundObjectEncounters()
       
        
    }
    
    func updateLetterEncounterPositions(){
        if player.position.x > nextLetterEncounterSpawnPosition{
            letterManager.placeLetterEncounter(currentEncounterPos: nextLetterEncounterSpawnPosition)
            nextLetterEncounterSpawnPosition += 1400
        }
    }
    
    func updateBackgroundObjectEncounters(){
        if player.position.x > nextBgEncounterSpawnPosition{
            bgObjectManager.placeEncounter(currentXPos: nextBgEncounterSpawnPosition)
            nextBgEncounterSpawnPosition += 1400
        }
        
    }
    
    
    func updateForegroundObjectEncounters(){
        if player.position.x > nextFgEncounterSpawnPosition{
            fgObjectManager.placeForegroundEncounter(atPosition: nextFgEncounterSpawnPosition)
            nextFgEncounterSpawnPosition += 1400
        }
    }
    
    func centerOnNode(node: SKNode){
        
        guard let world = self.world else { return }
        
        let nodePositionInScene = self.convert(node.position, from: world)
        
        world.position = CGPoint(x: world.position.x - nodePositionInScene.x - ScreenSizeConstants.HalfScreenWidth*0.60, y: world.position.y)
        
        
        
    }
    



    func updateMovingBackground(playerProgress: CGFloat){
        
        let groundJumpPosition = jumpCount*jumpWidth
        
        if(playerProgress >= groundJumpPosition){
            movingBackground.position.x += jumpWidth
            jumpCount += 1
        }
        
       
    }



}


//MARK: ************** CONTACT LOGIC

extension NGKBaseScene{
    func didBegin(_ contact: SKPhysicsContact) {
        
        let otherBody: SKPhysicsBody = (contact.bodyA.categoryBitMask & NGKPhysicsCategory.Player > 0) ? contact.bodyB : contact.bodyA
        
        let otherBodyPhysicsCategory = otherBody.categoryBitMask
       

        switch(otherBodyPhysicsCategory){
            case NGKPhysicsCategory.Letter:
                if let otherBodyNode = otherBody.node,let otherBodyName = otherBodyNode.name, let letter = Letter.LetterCategory(rawValue: otherBodyName)?.stringLetter{
                    
                    print(letter)
                    otherBodyNode.removeFromParent()
                    player.takeDamage()
                    
                }
                break
            case NGKPhysicsCategory.Enemy:
                break
            case NGKPhysicsCategory.NoncollidingEnemy:
                break
            case NGKPhysicsCategory.Barrier:
                break
            case NGKPhysicsCategory.Collectible:
                break
            case NGKPhysicsCategory.Portal:
                break
            default:
                print("No contact logic implemented")
            
        }
    }
}
