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
    
    var scene:GameScene?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        skview.showsFPS = true
        scene = GameScene.init(size: skview.frame.size)
        scene?.scaleMode = .ResizeFill
        scene?.backgroundColor = SKColor.brownColor()
        scene?.anchorPoint = CGPoint(x: 0.1, y: 0.1)
        skview.presentScene(scene)
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


    @IBAction func del(sender: AnyObject) {
    }
    @IBAction func add(sender: AnyObject) {
    }
}

