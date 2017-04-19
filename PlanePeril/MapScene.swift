//
//  MapScene.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/18/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import MapKit

class MapScene: SKScene{
    
    var mapView = MKMapView()
    
    var gameHasStarted: Bool = false
    var frameCount = 3.00
    var adjustedCurrentTime: TimeInterval = 0.00
    var adjustedLastUpdateTime: TimeInterval = 0.00
    var mapUpdateInterval: TimeInterval = 0.10

    var player = SKSpriteNode()
    
    var planeZRotation = CompassDirection.northEast.zRotation
    
    let mainMotionManager = MainMotionManager.sharedMotionManager
    
    //MARK: *********** Scene Life Cycle
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //Add player 
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "playerShip1_red"))
        player = SKSpriteNode(texture: texture)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint.zero
        
        addChild(player)
        player.zRotation = planeZRotation
        
        /**
         zRotation  0                               Compass Heading:    North
         zRotation CGFloat(M_PI)/CGFloat(2.00)      Compass Heading:    West
         zRotation CGFloat(M_PI)                    Compass Heading:    South
         zRotation CGFloat(M_PI)*CGFloat(3.00/2.00) Compass Heading:    East
         zRotation CGFloat(M_PI)*CGFloat(2.00)      Compass Heading:    North
         **/
        
        //Configure initial longitude and latitude of the mapView
        
        let centerCoordinate = CLLocationCoordinate2DMake(25.033499866, 121.558997764)
        
        //Latitude and longitude
        
        let latDelta = 0.0001
        let longDelta = 0.0001
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        mapView.region = MKCoordinateRegion(center: centerCoordinate, span: span)
        
        mapView.alpha = 0.60
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        if let view = self.view{
            
            view.addSubview(mapView)
            
            NSLayoutConstraint.activate([
                mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.00),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.00),
                mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.00),
                mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.00)
                ])
            
            
        }
        
        gameHasStarted = true
        
        
    
        
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    
    
    //MARK: ********* Game Loop Functions
    
    override func didEvaluateActions() {
        super.didEvaluateActions()
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        if mainMotionManager.isDeviceMotionAvailable && mainMotionManager.isGyroAvailable,let motionData = mainMotionManager.deviceMotion{
            
            let yaw = motionData.attitude.yaw
            let zRotationRate = motionData.rotationRate.z
            
            print("The yaw is \(yaw), and the zRotationRate is \(zRotationRate)")
            
            let rotationUnit = (2.00*M_PI)/Double(CompassDirection.allDirections.count)
            
            if(yaw/M_PI > 0 && zRotationRate > rotationUnit*7){
                player.zRotation += CGFloat(rotationUnit)
            }
            
            if(yaw/M_PI < 0 && zRotationRate < -rotationUnit*7){
                player.zRotation -= CGFloat(rotationUnit)
            }
            
           
        
            
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if(!gameHasStarted){
            adjustedCurrentTime = 0
        
        } else {
            adjustedCurrentTime = currentTime

        }
        
        frameCount += adjustedCurrentTime - adjustedLastUpdateTime
        print(frameCount)
        
        if(frameCount > mapUpdateInterval){
            
            let currentCoordinate = mapView.centerCoordinate
            
            /**
             0.0001 is the arbitrary travel distance for a single mapUpdateInterval
             
             atan(planeZRotation) = deltaLat/deltaLong
             deltaLat^2 + deltaLong^2 = 0.0001^2
             
             (deltaLong*atan(planeZRotation))^2 + deltaLong^2 = 0.0001^2
             (deltaLong^2)*(atan(planeZRotation)^2) + (deltaLong^2) = 0.0001^2
             (deltaLong^2)*(atan(planeZRotation)^2 + 1) = 0.0001^2
             (deltaLong^2)= 0.0001^2/(atan(planeZRotation)^2 + 1)
             deltaLong = sqrt(0.0001^2/(atan(planeZRotation)^2 + 1))
 
            **/
            
            let deltaLong = sqrt(pow(0.0001, 2.000)/(1.00+pow(atan(planeZRotation),2.00)))
            let deltaLat = sqrt(pow(0.0001,2.000)-pow(deltaLong,2.000))
            
            let adjustedLatitude = currentCoordinate.latitude + Double(deltaLat)
            let adjustedLongitude = currentCoordinate.longitude + Double(deltaLong)
            
            mapView.centerCoordinate = CLLocationCoordinate2DMake(adjustedLatitude, adjustedLongitude)
            
            frameCount = 0
        }
        
        
        adjustedLastUpdateTime = adjustedCurrentTime

       
    }
    
    
}
