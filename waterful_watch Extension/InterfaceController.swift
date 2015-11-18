//
//  InterfaceController.swift
//  waterful_watch Extension
//
//  Created by suz on 10/9/15.
//  Copyright © 2015 suz. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var consumed : Double = Double()
    var goal : Double = Double()
    var sipVolume : Double = Double()
    var cupVolume : Double = Double()
    var mugVolume : Double = Double()
    var bottleVolume : Double = Double()
    var unit : String = String()
    
    @IBOutlet var consumedLabel: WKInterfaceLabel!
    @IBOutlet var goalLabel: WKInterfaceLabel!
    
    @IBAction func button1Pressed() {
        sendAmount("sip")
        getStatus()
        self.updateView()
    }
    @IBAction func button2Pressed() {
        sendAmount("cup")
        getStatus()
        self.updateView()
    }
    @IBAction func button3Pressed() {
        sendAmount("mug")
        getStatus()
        self.updateView()
    }
    @IBAction func button4Pressed() {
        sendAmount("bottle")
        getStatus()
        self.updateView()
    }
    @IBOutlet var button1: WKInterfaceButton!
    @IBOutlet var button2: WKInterfaceButton!
    @IBOutlet var button3: WKInterfaceButton!
    @IBOutlet var button4: WKInterfaceButton!
    
    @IBAction func undoPressed() {
        undoLastWaterLog()
    }
    
    @IBAction func refreshPressed() {
        getStatus()
        getContainer()
    }
    
    override func didAppear() {
        getStatus()
        getContainer()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sendAmount(container: String){
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        let applicationDict = ["container" : container]
        do {
            try WCSession.defaultSession().updateApplicationContext(applicationDict)
            
        } catch {
            print("error")
        }
    }
    
    func getStatus() {
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        if WCSession.defaultSession().reachable == true {
            
            let request :[ String : AnyObject ] = ["command" : "fetchStatus"]
            let session = WCSession.defaultSession()
            
            session.sendMessage(request, replyHandler: { response in
                
                let res = response
                self.consumed = res["consumed"] as! Double
                self.goal = res["goal"] as! Double
                self.updateView()
                
                }, errorHandler: { error in
                    print("error: \(error)")
            })
        }
        
    }
    
    func getContainer() {
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        if WCSession.defaultSession().reachable == true {
            
            let request :[ String : AnyObject ] = ["command" : "fetchContainer"]
            let session = WCSession.defaultSession()
            
            session.sendMessage(request, replyHandler: { response in
                
                let res = response
                self.unit = res["unit"] as! String
                if self.unit == "mL" {
                    self.sipVolume = res["sipVolume"] as! Double
                    self.cupVolume = res["cupVolume"] as! Double
                    self.mugVolume = res["mugVolume"] as! Double
                    self.bottleVolume = res["bottleVolume"] as! Double
                }
                    // in watch, if user wants to use "oz", store variable as oz. because watch takes soooo long
                else if self.unit == "oz" {
                    self.sipVolume = (res["sipVolume"] as! Double).ml_to_oz
                    self.cupVolume = (res["cupVolume"] as! Double).ml_to_oz
                    self.mugVolume = (res["mugVolume"] as! Double).ml_to_oz
                    self.bottleVolume = (res["bottleVolume"] as! Double).ml_to_oz
                }
                
                self.updateView()
                
                }, errorHandler: { error in
                    print("error: \(error)")
            })
        }
        
    }
    
    func undoLastWaterLog() {
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        if WCSession.defaultSession().reachable == true {
            
            let request = ["command" : "undo"]
            let session = WCSession.defaultSession()
            
            session.sendMessage(request, replyHandler: { response in
                let res = response
                
                self.consumed = res["consumed"] as! Double
                
                self.updateView()
                
                }, errorHandler: { error in
                    print("error: \(error)")
            })
        }
    }
    
    func updateView() {
        
        consumedLabel.setText(consumed.toString)
        goalLabel.setText(goal.toString)
        
        button1.setTitle(sipVolume.toString + unit)
        button2.setTitle(cupVolume.toString + unit)
        button3.setTitle(mugVolume.toString + unit)
        button4.setTitle(bottleVolume.toString + unit)
        
    }
    
    
}
