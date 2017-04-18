//
//  WeaponGrade.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation


struct WeaponGrade: OptionSet{
    
    var rawValue: UInt32
    
    static let None = WeaponGrade(rawValue: 0 << 0)
    static let GradeA = WeaponGrade(rawValue: 1 << 0)   //1
    static let GradeB = WeaponGrade(rawValue: 1 << 1)   //2
    static let GradeC = WeaponGrade(rawValue: 1 << 2)   //4
    static let GradeD = WeaponGrade(rawValue: 1 << 3)   //8
    static let GradeE = WeaponGrade(rawValue: 1 << 4)   //16
    
    /** 
     Upgrading weapons expands the membership set of the weapon grade to a larger category; lower grade capabilities are still included in the higher grade capabilities
    **/
    mutating func upgradeWeapon(){
        if(rawValue < WeaponGrade.GradeE.rawValue){
            rawValue = rawValue | rawValue << 1
        }
    }
    
    /** 
     Downgrading reduces the membership set of the weapon grade such that lower grade capabilities are still available while higher level capabilities are lost
    **/
    mutating func downGradeWeapon(){
        
        if(rawValue > 0){
            rawValue = rawValue & (rawValue >> 1)
        }
    }
    
    
    func hasGradeACapability() -> Bool{
        return rawValue & WeaponGrade.GradeA.rawValue > 0
    }
    
    func hasGradeBCapability() -> Bool{
        return rawValue & WeaponGrade.GradeB.rawValue > 0
    }
    
    func hasGradeCCapability() -> Bool{
        return rawValue & WeaponGrade.GradeC.rawValue > 0
    }
    
    func hasGradeECapability() -> Bool{
        return rawValue & WeaponGrade.GradeD.rawValue > 0
    }
    
    mutating func removeWeaponGrade(weaponGrade: WeaponGrade){
        rawValue = rawValue ^ weaponGrade.rawValue
    }
    
    mutating func addWeaponGrade(weaponGrade: WeaponGrade){
        rawValue = rawValue | weaponGrade.rawValue
    }
}
