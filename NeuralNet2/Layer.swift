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
    private (set) var totalErr:[CGFloat] = []
    
    
    
    
    
    func setInputsAndRun(inputs:[CGFloat]) {
        
        self.inputs = inputs
        
        if type == LayerTypeName.input {

            syncNeuronCountToInputsCount()
            outputs = inputs
            outLayer?.setInputsAndRun(inputs)

        }
            
            
        else {
            updateNeuronsAndRun()
        }
        
    }
    
    
    
    
    func updateNeuronsAndRun() {
        
        let neurons = self.neurons
        let inputs = self.inputs
        var sequence:[SKAction] = []
        
        
        //create a action sequence which calls neuron one after an other
        for idx in 0...neurons.count-1 {
            
            let act = SKAction.runBlock({
                neurons[idx].setInputsAndCalc(inputs)
            })
            
            sequence.append(act)
            sequence.append(waitAction)
        }
        
        
        //add next step
        sequence.append(
            SKAction.runBlock({
                self.updateOutputsAndCallNextLayer()
            })
        )
        
        //start running
        runAction(SKAction.sequence(sequence),withKey:"step" )
    }
    
    
    func updateOutputsAndCallNextLayer() {
        
        
        
        //update output list
        
        outputs.removeAll()
        for nn in neurons {
            outputs.append(nn.output)
        }
        
        print("\n")
        print("layer output:",outputs)
        print("\n")
        
        
        
        //call next layer to update
        runAction(waitAction) {
            self.outLayer?.setInputsAndRun(self.outputs)
        }
        
    }
    
    
    
    // MARK: Layer GUI
    
    
    private (set) var type:String = LayerTypeName.unkown
    private (set) var inLayer:Layer?
    
    
    
    
    
    
    
    
    var outLayer:Layer? {
        didSet {
            outLayer?.inLayer = self
        }
    }
    
    var neurons:[Neuron] {
        return children.filter({ (node) -> Bool in
            return node is Neuron
        }) as! [Neuron]
    }
    

    
    
    

    
    func syncNeuronCountToInputsCount() {

        while inputs.count > self.neurons.count {
            self.addNeuron()
        }
        
        while inputs.count < self.neurons.count {
            self.delNeuron()
        }
        
    }
    
    
    
    
    
    // MARK: create custom layers
    
    
    class func newHiddenLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = LayerTypeName.hidden
        ly.type = LayerTypeName.hidden
        
        for _ in 0...3 {
            ly.addNeuron()
        }
        return ly
    }
    
    
    class func newInputLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = LayerTypeName.input
        ly.type = LayerTypeName.input
        
        for _ in 0...1 {
            ly.addNeuron()
        }
        return ly
    }
    
    
    
    class func newOutputLayer() -> Layer {
        
        let ly = Layer()
        ly.userInteractionEnabled = true
        ly.name = LayerTypeName.output
        ly.type = LayerTypeName.output
        
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
        
        if name == LayerTypeName.input  { nn = Neuron.InputNeuron()   }
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



