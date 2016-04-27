//
//  Layer.swift
//  NeuralNetwork
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 admin. All rights reserved.
//


import Cocoa
import SpriteKit


class Layer: SKNode {
    
    
    var inLayer:Layer?
    var outLayer:Layer?
    
    var neurons:[Neuron]{
        return children.filter({ (node) -> Bool in
            return node.isKindOfClass(Neuron)
        }) as! [Neuron]
    }
    
    
    
    // MARK: create custom layers
    
    
    class func newHiddenLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = "hidden layer"
        for _ in 0...3 {
            ly.addNeuron()
        }
        return ly
    }
    
    
    class func newInputLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = "input layer"
        for _ in 0...1 {
            ly.addNeuron()
        }
        return ly
    }
    
    
    
    class func newOutputLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = "output layer"
        for _ in 0...3 {
            ly.addNeuron()
        }
        return ly
    }
    
    
    func drawConnection() {
        
        for nn in neurons {
            nn.drawConnections()
        }
    }
    
    
    // MARK:UI Logic
    
    
    
    func addNeuron() {
        
        if children.count >= 8 {
            return
        }
        
        
        var newNeuron:Neuron
        
        if isInputLayer() {
            newNeuron = Neuron.InputNeuron()
        }
            
        else if isOutputLayer() {
            newNeuron = Neuron.OutputNeuron()
        }
            
        else {
            newNeuron = Neuron.HiddenNeuron()
        }
        
        newNeuron.parentLayer = self
        addChild(newNeuron)
        
        nodesDidChange()
    }
    
    
    func delNeuron() {
        
        if children.count <= 2  {
            return
        }
        
        let lastNode = children.last as? Neuron
        lastNode?.removeFromParent()
        nodesDidChange()
    }
    
    
    
    
    
    func isOutputLayer() -> Bool {
        return (name == "output layer")
    }
    
    func isInputLayer() -> Bool {
        return (name == "input layer")
    }
    
    func isHiddenLayer() -> Bool {
        return (name == "hidden layer")
    }
    
    
    
    
    
    
    
    override func addChild(node: SKNode) {
        
        if !children.isEmpty {
            
            var pos = children.last?.position
            pos?.y += 35
            node.position = pos!
        }
        super.addChild(node)
    }
    
    
    
    
    
    
    
    override func mouseUp(theEvent: NSEvent) {
        
        var newPos = self.position
        let dx = newPos.x%50
        let dy = newPos.y%35
        
        newPos.x -= dx
        newPos.y -= dy
        
        if dx>25 {
            newPos.x += 50
        }
        
        if dy>17.5 {
            newPos.y += 35
        }
        
        position = newPos
        
        positionDidChange()
        
    }
    
    
    
    
    
    override func mouseDragged(theEvent: NSEvent) {
        
        var newPos = self.position
        newPos.x += theEvent.deltaX
        newPos.y -= theEvent.deltaY
        
        self.position = newPos
        
        
        positionDidChange()
        
    }
    
    override func rightMouseUp(theEvent: NSEvent) {
        print(self)
    }
    
    func positionDidChange() {
        self.drawConnection()
        self.outLayer?.drawConnection()
    }
    
    func nodesDidChange() {
        self.drawConnection()
        self.outLayer?.drawConnection()
        
    }
}



