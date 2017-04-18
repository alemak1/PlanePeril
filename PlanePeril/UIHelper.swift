//
//  UIHelper.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class UIHelper{
    
    
    func changeLabelSet(fromOriginalLabels labels: [UILabel], withNewFont newFontType: UIFont) -> [UILabel]{
        return labels.map({
            $0.font = newFontType
            return $0
        })
    }
    
    func getLabelSetWithFonts(fromOriginalLabels labels: [UILabel], withNewFont newFontType: UIFont) -> [UILabel]{
        return labels.map({
            let newLabel = $0.copy() as! UILabel
            newLabel.font = newFontType
            return newLabel
        })
    }
    
    /** Combines the strings from several different labels to provide the text for a single label whose formatting is based on that of the first label among those whose text is combined
 
    **/
    func combineLabels(fromOriginalLabels labels: [UILabel]) -> UILabel{
        
        let firstLabel = labels.first!
        let finalLabel = UILabel()
        finalLabel.font = firstLabel.font
        finalLabel.textColor = firstLabel.textColor
        finalLabel.textAlignment = firstLabel.textAlignment
        
        let labelsWithText = labels.filter({ $0.text != nil })
        
        let labelTexts: [String] = labelsWithText.map({ $0.text! })
        
        finalLabel.text = labelTexts.reduce(""){
            text1, text2 in
            
            return "\(text1) \(text2)"
        }
        
        return finalLabel
            
        }
}
