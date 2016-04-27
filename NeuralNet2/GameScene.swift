//
//  Scene.swift
//  NeuralNetwork
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 admin. All rights reserved.
//
import SpriteKit
import Cocoa

class GameScene: SKScene {
    
    
    
    // MARK: logic block
    
    
    func start() {
        let inputs = [1,1,1] as [CGFloat]
        inLayer.setInputsAndRun(inputs)
        
        target?.performSelector(action, withObject:"abc")
    }
        
    
    
    
    // MARK: GUI
    
    var inLayer = Layer.newInputLayer()
    var outLayer = Layer.newOutputLayer()
    
    var target:AnyObject?
    var action:AnyObject?
    
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        addChild(inLayer)
        addChild(outLayer)
        
        inLayer.outLayer = outLayer
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func drawConnections() {
        
        enumerateChildNodesWithName("*layer") { (node, _) in
            let ly = node as! Layer
            ly.drawConnection()
        }
        
    }
    
    
    func addHiddenLayer() {
        
        if children.count < 7 {
            
            outLayer.removeFromParent()
            let newLayer = Layer.newHiddenLayer()
            let lastNode = outLayer.inLayer
            
            newLayer.outLayer = outLayer
            lastNode?.outLayer = newLayer
            
            addChild(newLayer)
            addChild(outLayer)
            
            
            newLayer.drawConnection()
            outLayer.drawConnection()
        }
        
    }
    
    
    
    func delLayer() {
        
        if children.count > 2 {
            
            outLayer.removeFromParent()
            
            let lastNode = outLayer.inLayer?.inLayer //last item
            outLayer.inLayer?.removeFromParent()
            lastNode?.outLayer = outLayer
            
            addChild(outLayer)
            outLayer.drawConnection()
        }
        
    }
    
    
    
    
    
    override func addChild(node: SKNode) {
        
        if !children.isEmpty {
            
            var pos = children.last?.position
            pos?.x += 50
            node.position = pos!
        }
        
        
        super.addChild(node)
    }
    
    
}





