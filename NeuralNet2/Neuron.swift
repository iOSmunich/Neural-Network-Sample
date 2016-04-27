//
//  Neuron.swift
//  NeuralNetwork
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import Cocoa
import SpriteKit

class Neuron: SKNode {
    
    // MARK: properties
    
    private var bgNode:BgNode = BgNode(color: SKColor.grayColor(), size:CGSizeMake(20, 20))
    
    var lines:SKNode = SKNode()
    
    var parentLayer:Layer!
    
    var inNeurons:[Neuron] {
        
        if let _ = parentLayer.inLayer?.neurons {
            return parentLayer.inLayer!.neurons
        }
        
        return []
    }
    
    

    
    
    
    // MARK: input neuron, output neuron, hidden neuron
    
    class func InputNeuron() -> Neuron {
        
        let nn = Neuron.HiddenNeuron()
        nn.name = "input neuron"
        nn.bgNode.color = SKColor.redColor()
        return nn
    }
    
    
    
    
    
    
    class func OutputNeuron() -> Neuron {
        
        let nn = Neuron.HiddenNeuron()
        nn.name = "output neuron"
        nn.bgNode.color = SKColor.greenColor()
        return nn
    }
    
    
    
    
    
    
    class func HiddenNeuron() -> Neuron {
        
        let nn = Neuron()
        nn.name = "neuron"
        nn.addChild(nn.bgNode)
        
        nn.bgNode.name = "neuron bg node"
        nn.lines.name = "lines"
        nn.lines.zPosition = -100
        nn.lines.userInteractionEnabled = true
        
        nn.addChild(nn.lines)
        return nn
    }
    
    

    
    
    // MARK: draw function
    
    func drawConnections() {
        
        lines.removeAllChildren()
        
        
        
        for node in inNeurons {
            
            let p0 = convertPoint(node.position, fromNode: node.parent!)
            let p3 = convertPoint(position, fromNode: parent!)
            
            let dx = (p3.x - p0.x)/3.0
            let dy = (p3.y - p0.y)/5.0
            
            
            let p1 = CGPointMake(p0.x+dx,p0.y+dy)
            let p2 = CGPointMake(p3.x-dx,p3.y-dy)
            
            var points:[CGPoint] = [p0,p1,p2,p3]
            
            let spline = SKShapeNode(splinePoints: &points, count: 4)
            spline.name = "spline"
            spline.zPosition = -100
            lines.addChild(spline)
            
        }
        
    }
    
    
    
}


// MARK: background node extension for mouse event handler


class BgNode: SKSpriteNode {
    
    
    override func rightMouseUp(theEvent: NSEvent) {
        print(theEvent.locationInNode(scene!))
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











