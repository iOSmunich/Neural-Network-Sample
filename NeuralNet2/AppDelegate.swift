//
//  AppDelegate.swift
//  NeuralNetwork
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skview: SKView!
    @IBOutlet weak var txtField: NSTextField!
    
    
    
    var scene:GameScene!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        skview.showsFPS = true
        scene = GameScene.init(size: skview.frame.size)
        scene?.scaleMode = .ResizeFill
        scene?.anchorPoint = CGPoint(x: 0.1, y: 0.1)
        skview.presentScene(scene)
        
        
        

        
        scene.showInfo_callback = { (msg:AnyObject) -> () in
            
            let infos = (msg as! String) + "\n"
            self.txtField.stringValue.appendContentsOf(infos)
        }
        
    }
    
    
    

    

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func start(sender: AnyObject) {
        scene.paused = false

        scene.start()
    }

    @IBAction func stop(sender: AnyObject) {
        
        scene.paused = !scene.paused
        
        if let btn = sender as? NSButton {
            btn.title = scene.paused ? "continue" : "stop"
        }
    }

    @IBAction func del(sender: AnyObject) {
        scene.delLayer()
    }
    @IBAction func add(sender: AnyObject) {
        scene.addHiddenLayer()
    }
    
    
    

    
    
    
}



extension SKView {
    
    public override func rightMouseUp(theEvent: NSEvent) {
        let node = scene?.nodeAtPoint(theEvent.locationInNode(scene!))
        node?.rightMouseUp(theEvent)
    }
    
    public override func scrollWheel(theEvent: NSEvent) {
        let node = scene?.nodeAtPoint(theEvent.locationInNode(scene!))
        node?.scrollWheel(theEvent)
    }
}