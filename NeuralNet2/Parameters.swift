//
//  Parameters.swift
//  NeuralNet2
//
//  Created by admin on 16/4/27.
//  Copyright © 2016年 admin. All rights reserved.
//


import GameplayKit.GKRandomSource
import SpriteKit.SKAction





enum LayerTypeName {
    
    static let hidden = "input layer"
    static let input  = "hidden layer"
    static let output = "output layer"
    static let unkown = "unkonw layer"
}


enum NeuronType {
    
    static let hidden = "input neuron"
    static let input  = "hidden neuron"
    static let output = "output neuron"
    static let unkown = "unkonw neuron"
    
    enum subType {
        static let bgNode   = "neuron bg node"
        static let spline   = "spline"
        static let line     = "lines"
    }
}






let gaussDistribution   =   GKGaussianDistribution(randomSource: GKARC4RandomSource(), lowestValue: -1000, highestValue: +1000)
let waitAction          =   SKAction.waitForDuration(0.01)


var showSpline:Bool = true
let showPrintInfo   = true


let learnRate = 0.03

