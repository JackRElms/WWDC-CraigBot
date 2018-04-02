import Foundation

import Foundation
import AVFoundation
import SpriteKit

public class StartWWDC: SKScene {
    let startWWDC = SKSpriteNode(imageNamed: "startwwdc.png")
    let keynoteBG = SKSpriteNode(imageNamed: "wwdc18wp.png")
    let stage = SKSpriteNode(imageNamed: "WWDC.png")
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
    let removeNode = SKAction.removeFromParent()
    let wait = SKAction.wait(forDuration: 1.5)
    let keynoteMessage = SKLabelNode(fontNamed: "San Francisco")
    var splashCount = 0
    var bg = UIBezierPath()
    var audioPlayer = AVAudioPlayer()
    let splashMessages = ["See you in San Jose", "ThankYou!!!"]
    
    override public func didMove(to view: SKView) {
        setupScene()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { self.bestWWDCEver() })
    }
    
    func setupScene() {
        self.backgroundColor = .black
        
        keynoteMessage.position = CGPoint(x: self.frame.midX, y:self.frame.midY + 115)
        keynoteMessage.fontColor = .black
        keynoteMessage.numberOfLines = 3
        keynoteMessage.fontSize = 45
        keynoteMessage.alpha = 0
        keynoteMessage.zPosition = 2
        keynoteMessage.horizontalAlignmentMode = .center
        keynoteMessage.verticalAlignmentMode = .center
        self.addChild(self.keynoteMessage)
        stage.position = CGPoint(x: self.frame.midX ,y: self.frame.midY)
        stage.zPosition = 1
        self.addChild(stage)
        
        keynoteBG.position = CGPoint(x: self.frame.midX ,y: self.frame.midY+100)
        keynoteBG.zPosition = 1
        self.addChild(keynoteBG)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { self.keynoteBG.run(self.fadeOut) })
    }
    
    func displayText() {
        let outSequence = SKAction.sequence([wait, fadeOut])
        keynoteMessage.run(outSequence, completion: {
            self.keynoteMessage.text = self.splashMessages[self.splashCount]
            self.keynoteMessage.run(self.fadeIn, completion:{
                self.splashCount += 1
                if self.splashCount < self.splashMessages.count {
                    self.keynoteMessage.run(outSequence)
                    self.displayText()
                } else if self.splashCount == self.splashMessages.count {
                    print("Thankyou so much for reviewing my application, i've had a blast making it!!!!, have an amazing day and maybe I will even see you at WWDC!!")
                }
            })
        })
    }
    
    func bestWWDCEver() {
        displayText()
        let soundURL = Bundle.main.url(forResource: "bestwwdcever", withExtension: "mp3")
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        self.audioPlayer.play()
    }
}


