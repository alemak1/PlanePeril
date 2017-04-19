//
//  NGKBaseScene+ScreenRecording.swift
//  PlanePeril
//
//  Created by Aleksander Makedonski on 4/19/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import ReplayKit

/** This extension allows a scene's GamePlay to be recorded with ReplayKit
 
 **/

extension NGKBaseScene: RPPreviewViewControllerDelegate, RPScreenRecorderDelegate{
    
    var screenRecordingToggleEnabled: Bool{
        return UserDefaults.standard.bool(forKey: "screenRecorderEnabled")
    }
    
    //MARK: Start/Stop ScreenRecording
    
    func startScreenRecording(){
        
        
    }
    
    func stopScreenRecording(withHandler handler: @escaping (() -> Void)){
        
    }
    
    func showScreenRecordingAlert(message: String){
        
    }
    
    func discardRecording(){
        
        
    }
    
    //MARK: RPScreenRecorderDelegate
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWithError error: Error, previewViewController: RPPreviewViewController?) {
        
    }
    
    //MARK: RPPreviewViewControllerDelegate 
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }
}
