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
    
    
    // MARK: Layer logic block
    
    private (set) var inputs:[CGFloat] = []
    private (set) var outputs:[CGFloat] = []
    
    
    func setInputsAndRun(inputs:[CGFloat]) {
    
        self.inputs = inputs

        
        //let each neuron do calc
        for nn in neurons {
            nn.setInputsAndCalc(self.inputs)
        }
        
        
        
        //let make output list
        outputs.removeAll()
        for nn in neurons {
            outputs.append(nn.output)
        }
        
        print("\n")
        print("layer output:",outputs)
        print("\n")

        
        
        //call next layer to update
        runAction(SKAction.waitForDuration(0.5)) { 
            self.outLayer?.setInputsAndRun(self.outputs)
        }
    }
    
    
    
    
    // MARK: Layer GUI
    
    
    
    
    struct LayerTypeName {
        
        static let hidden = "input layer"
        static let input  = "hidden layer"
        static let output = "output layer"
    }
    
    
    private (set) var inLayer:Layer?
    var outLayer:Layer? {
        didSet {
            outLayer?.inLayer = self
        }
    }
    
    var neurons:[Neuron]{
        return children.filter({ (node) -> Bool in
            return node is Neuron
        }) as! [Neuron]
    }
    
    
    
    // MARK: create custom layers
    
    
    class func newHiddenLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = LayerTypeName.hidden
        for _ in 0...3 {
            ly.addNeuron()
        }
        return ly
    }
    
    
    class func newInputLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = LayerTypeName.input
        for _ in 0...1 {
            ly.addNeuron()
        }
        return ly
    }
    
    
    
    class func newOutputLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = LayerTypeName.output
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
        

        var nn:Neuron = Neuron.HiddenNeuron()
        
        if name == LayerTypeName.input  { nn =  Neuron.InputNeuron()  }
        if name == LayerTypeName.output { nn = Neuron.OutputNeuron()  }
        
        
        addChild(nn)
        nn.parentLayer = self
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
        return (name == LayerTypeName.output)
    }
    
    func isInputLayer() -> Bool {
        return (name == LayerTypeName.input)
    }
    
    func isHiddenLayer() -> Bool {
        return (name == LayerTypeName.hidden)
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
    

    func positionDidChange() {
        self.drawConnection()
        self.outLayer?.drawConnection()
    }
    
    func nodesDidChange() {
        self.drawConnection()
        self.outLayer?.drawConnection()
        
    }
}



