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
    
    var inLayer = Layer.newInputLayer()
    var outLayer = Layer.newOutputLayer()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        addChild(inLayer)
        addChild(outLayer)
        
        inLayer.outLayer = outLayer
        outLayer.inLayer = inLayer
        
        
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
            let lastLayer = outLayer.inLayer
            
            newLayer.inLayer = lastLayer
            newLayer.outLayer = outLayer
            lastLayer?.outLayer = newLayer
            outLayer.inLayer = newLayer
            
            addChild(newLayer)
            addChild(outLayer)
            
            
            newLayer.drawConnection()
            outLayer.drawConnection()
        }
        
    }
    
    
    
    func delLayer() {
        
        if children.count > 2 {
            
            outLayer.removeFromParent()
            
            let inLayer = outLayer.inLayer?.inLayer
            outLayer.inLayer?.removeFromParent()
            outLayer.inLayer = inLayer
            inLayer?.outLayer = outLayer
            
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





