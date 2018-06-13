//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
import PlaygroundSupport

// Set up containing view
let frame = CGRect(x: 0, y: 0, width: 600, height: 570)
// Add main scene
var scene = SplashScreen(size: frame.size)
let view = SKView(frame: frame)
view.presentScene(scene)
PlaygroundPage.current.liveView = view


