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
import GameplayKit
import MapKit



class NGKBaseScene: SKScene, SKPhysicsContactDelegate{
    
    //MARK: Experimental Enemies
    var frog: Frog!
    
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
    
    
   
    //MARK: ******** Target-Word/In-Progress Word (When the In-Progress word matches the Target Word, the scene changes to a success state)
    

    var targetWord: String!
    var inProgressWord: String!
    
    
    //MARK: ******** MotionManger 
    
    var motionManager = MainMotionManager.sharedMotionManager
    
    //MARK: ************ State Machine (for managing different scene states; a success state is achieved when the In-Progress Word matches the Target Word; a fail state occurs when the player either runs out of fuel or when health level diminishes to zero; a pause state occurs when the player presses the pause button)
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        NGKBaseSceneActiveState(levelScene: self),
        NGKBaseScenePauseState(levelScene: self),
        NGKBaseSceneFailState(levelScene: self),
        NGKBaseSceneSuccessState(levelScene: self),

        
        ])
    
    
    //MARK: ********** Initializers 
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    convenience init(size: CGSize, levelConfiguration: NGKBaseLevelConfiguration) {
        self.init(size: size)
        
        self.targetWord = levelConfiguration.targetWord
        self.inProgressWord = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //Configure the plane animations dictionary before instantiating the first player
        Player.ConfigurePlaneAnimations()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        configureWorld()
        
        player = Player(color: .Blue, playerStartXPos: Double(playerStartXPos), normalForwardVelocity: 100)
        
        
        world.addChild(player)
        
    
        let cliffPoint = CGPoint(x: 600, y: 10)
        
        let cliffNodeLeftTexture = SKTexture(image: #imageLiteral(resourceName: "grassCliff_left"))
        let cliffNodeLeftSize = cliffNodeLeftTexture.size()
        let cliffNodeLeft = SKSpriteNode(texture: cliffNodeLeftTexture)
        cliffNodeLeft.xScale *= 0.50
        cliffNodeLeft.yScale *= 0.50

        cliffNodeLeft.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        cliffNodeLeft.position = cliffPoint
        cliffNodeLeft.physicsBody = SKPhysicsBody(texture: cliffNodeLeftTexture, size: cliffNodeLeftSize)
        cliffNodeLeft.physicsBody?.affectedByGravity = false
        cliffNodeLeft.physicsBody?.isDynamic = false
        
        let cliffNodeRightTexture = SKTexture(image: #imageLiteral(resourceName: "grassCliff_right"))
        let cliffNodeRightSize = cliffNodeRightTexture.size()
        let cliffNodeRight = SKSpriteNode(texture: cliffNodeRightTexture)
        cliffNodeRight.anchorPoint = CGPoint(x: 0, y: 1.0)
        cliffNodeRight.position = cliffPoint
        cliffNodeRight.physicsBody = SKPhysicsBody(texture: cliffNodeRightTexture, size: cliffNodeRightSize)
        cliffNodeRight.physicsBody?.affectedByGravity = false
        cliffNodeRight.physicsBody?.isDynamic = false
        cliffNodeRight.xScale *= 0.50
        cliffNodeRight.yScale *= 0.50

        world.addChild(cliffNodeRight)
        world.addChild(cliffNodeLeft)
        
        if let newFrog = Frog(position: cliffPoint, scalingFactor: 0.40, jumpActionDelay: 5.0){
            self.frog = newFrog
            world.addChild(frog)
            self.frog.position = CGPoint(x: cliffPoint.x, y: cliffPoint.y + 40)
        }
        
        
        if let cliff2 = SKScene(fileNamed: "PreviewScene")?.childNode(withName: "Island1"){
            cliff2.move(toParent: world)
            cliff2.position = CGPoint(x: cliffPoint.x + 100, y: cliffPoint.y)
        }
        
        
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
        frog.update(deltaTime: dt)
        
        //Update the stateMachine for the NGKBaseScene
        stateMachine.update(deltaTime: dt)
       
        
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
            case NGKCollisionConfiguration.Letter.rawValue:
                if let otherBodyNode = otherBody.node,let otherBodyName = otherBodyNode.name, let letter = Letter.LetterCategory(rawValue: otherBodyName)?.stringLetter{
                    print(letter)
                    otherBodyNode.removeFromParent()
                }
                break
            case NGKCollisionConfiguration.Enemy.rawValue:
                print("Hit an enemy")
                player.takeDamage()
                break
            case NGKCollisionConfiguration.Barrier.rawValue:
                print("Hit a barrier")
                break
            case NGKCollisionConfiguration.Collectible.rawValue:
                break
                print("Hit a collectible item")
            case NGKCollisionConfiguration.NonCollidingEnemy.rawValue:
                print("Hit a non-colliding enemy")
                break
            case NGKCollisionConfiguration.Portal.rawValue:
                print("Hit a portal")
                break
            default:
                print("No contact logic implemented")
            
        }
    }
}
