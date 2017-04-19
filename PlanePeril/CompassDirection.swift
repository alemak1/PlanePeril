//
//  CompassDirection.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/18/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import CoreGraphics

enum CompassDirection: Int{
    case north = 0, northByNorthWest, northWest, westByNorthWest
    case west, westBySouthWest, southWest, southBySouthWest
    case south, southBySouthEast, southEast, eastBySouthEast
    case east, eastByNorthEast, northEast, northByNorthEast
    
    //Helper method to get array of all possible compass directions 
    static let allDirections: [CompassDirection] = [
        .north, .northByNorthWest, .northWest, .westByNorthWest,
        .west, .westBySouthWest, .southWest, .southBySouthWest,
        .south, .southBySouthEast, .southEast, .eastBySouthEast,
        .east, .eastByNorthEast, .northEast, .northByNorthEast
    ]
    
    //Angle of orientation represented by the compass direction
    
    var zRotation: CGFloat{
        get{
            let stepSize = CGFloat(2*M_PI)/CGFloat(CompassDirection.allDirections.count)
            
            return stepSize*CGFloat(self.rawValue)
        }
    }
    
    //Initializer that takes a zRotation and converts it into a compass direction
    
    init(zRotation: CGFloat){
        
        let twoPi = Double(2.00)*M_PI
        
        let zRotation = (Double(zRotation) + twoPi).truncatingRemainder(dividingBy: twoPi)
        
        let orientation = zRotation/twoPi
        
        let rawFacingValue = round(orientation*16.0).truncatingRemainder(dividingBy: twoPi)
        
        self = CompassDirection(rawValue: Int(rawFacingValue))!
        
        
        
    }
    
    
    //Convenience initializer that takes a direction represented by a string 
    init(directionString: String){
        
        switch directionString {
        case "North","north":
            self = .north
            break
        case "NorthEast", "Northeast","northeast":
            self = .northEast
            break
        case "NorthWest","Northwest","northwest":
            self = .northWest
            break
        case "East","east":
            self = .east
            break
        case "SouthEast","Southeast","southeast":
            self = .southEast
            break
        case "SouthWest","Southwest","southwest":
            self = .southWest
            break
        case "South","south":
            self = .south
            break
        case "East","east":
            self = .east
            break
        case "West","west":
            self = .west
            break
        default:
            fatalError("Fatal error: unknown or unsupported string \(directionString)")
        }
        
    }
}

