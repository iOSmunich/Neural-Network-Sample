//
//  Neuron.swift
//  NeuralNetwork
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit.GKRandomSource

class Neuron: SKNode {
    

    
    var target:CGFloat!
    var delta:CGFloat!
    var totalErr:CGFloat!
    
    
    
    // MARK: neuron logic
    private (set) var inputs:[CGFloat]  = []
    private (set) var weights:[CGFloat] = []
    private (set) var bias:CGFloat      = 0
    private (set) var sum:CGFloat       = 0
    private (set) var output:CGFloat    = 0
    
    
    
    
    
    func setInputsAndCalc(inputs:[CGFloat]) {
        self.inputs = inputs
        syncWeights()
        calc()
    }
    
    
    

    private func calc() {
        
        self.bgNode.setScale(1.2)
        self.runAction(SKAction.waitForDuration(0.3)) {
            self.bgNode.setScale(1.0)
        }

        //calc sum
        sum = 0
        for (idx,input) in inputs.enumerate() {
            sum += input * weights[idx]
        }
        sum += bias
        output = max(0,sum)

        print("\n")
        print("inputs  =",inputs)
        print("weights =",weights)
        print("sum     =",sum)
        print("output  =",output)
        print("\n")

    }
    
    
    
    // MARK: properties
    
    private var bgNode:BgNode = BgNode(color: SKColor.grayColor(), size:CGSizeMake(20, 20))
    private let lines:SKNode = SKNode()
    
    
    
    var parentLayer:Layer!
    var type:String! = NeuronType.unkown
    var inputNeurons:[Neuron]? { return parentLayer?.inLayer?.neurons }
    
    
}



extension Neuron {
    
    
    
    private func syncWeights() {
        
        
        
        //sync weights count
        while weights.count < inputs.count {
            weights.append(randomWeight())
        }
        while weights.count > inputs.count {
            weights.removeLast()
        }
        
    }
    
    
    
    func randomWeight() -> CGFloat {
        let vv = gaussDistribution.nextUniform()
        return CGFloat(vv)
    }
    
    
    
    // MARK: input neuron, output neuron, hidden neuron
    
    class func InputNeuron() -> Neuron {
        
        let nn = Neuron.HiddenNeuron()
        nn.name = NeuronType.input
        nn.type = NeuronType.input
        nn.bgNode.color = SKColor.redColor()
        return nn
    }
    
    
    
    class func OutputNeuron() -> Neuron {
        
        let nn = Neuron.HiddenNeuron()
        nn.name = NeuronType.output
        nn.type = NeuronType.output
        nn.bgNode.color = SKColor.greenColor()
        return nn
    }
    
    
    
    
    
    
    class func HiddenNeuron() -> Neuron {
        
        let nn = Neuron()
        nn.name = NeuronType.hidden
        nn.type = NeuronType.hidden
        
        
        nn.addChild(nn.bgNode)
        nn.bgNode.name = NeuronType.subType.bgNode
        
        
        nn.lines.name = NeuronType.subType.line
        nn.lines.zPosition = -100
        nn.lines.userInteractionEnabled = true
        nn.addChild(nn.lines)
        
        
        
        return nn
    }
    
    
    private func updateLineWidth() {
        
        for (idx,line) in lines.children.enumerate() {
            let spline = line as! SKShapeNode
            spline.lineWidth = CGFloat(abs(weights[idx]))
            
        }
    }
    
    
    // MARK: draw function
    
    func drawConnections() {
        
        
        guard showSpline else {
            lines.hidden = true
            return
        }
        
        
        guard let _ = inputNeurons else {
            return
        }
        
        
        lines.removeAllChildren()
        
        for node in inputNeurons! {
            
            let p0 = convertPoint(node.position, fromNode: node.parent!)
            let p3 = convertPoint(position, fromNode: parent!)
            
            let dx = (p3.x - p0.x)/3.0
            let dy = (p3.y - p0.y)/5.0
            
            
            let p1 = CGPointMake(p0.x+dx,p0.y+dy)
            let p2 = CGPointMake(p3.x-dx,p3.y-dy)
            
            var points:[CGPoint] = [p0,p1,p2,p3]
            
            let spline = SKShapeNode(splinePoints: &points, count: 4)
            spline.name = NeuronType.subType.spline
            spline.zPosition = -100
            lines.addChild(spline)
        }
        
    }
    
    
    
}



// MARK: background node extension for mouse event handler


class BgNode: SKSpriteNode {
    
    
    override func rightMouseUp(theEvent: NSEvent) {
        parent?.rightMouseUp(theEvent)
    }
    
    override func scrollWheel(theEvent: NSEvent) {
        
        let layer = parent?.parent as? Layer
        
        if theEvent.deltaY > 0 {
            layer?.delNeuron()
            
        }
            
        else if theEvent.deltaY < 0 {
            layer?.addNeuron()
        }
    }
    
    
}










