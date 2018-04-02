import Foundation
import AVFoundation
import SpriteKit

public class Intro: SKScene {
    
    let iPhone = SKSpriteNode(imageNamed: "iphone.png")
    let iPhoneempty = SKSpriteNode(imageNamed: "iphoneempty.png")
    let displayLabel = SKLabelNode(fontNamed: "San Francisco")
    let splashMessages = ["After the app\napocalypse of 2017\nthe world is still struggling\nto cope without apps", "Its the day of the\nWWDC 2018 keynote and\nCraig doesn't know his\nway to the conference", "With no Craig at WWDC\nthere will be nobody to\npresent the keynote!!","Craig needs your help\nto find his way\nto the convention centre\nin time for the keynote"]
    var bg = UIBezierPath()
    var speechSynth:AVSpeechSynthesizer? = AVSpeechSynthesizer()
    var audioPlayer = AVAudioPlayer()
    var splashCount = 0
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
    let wait = SKAction.wait(forDuration: 5)
    let removeNode = SKAction.removeFromParent()
    
    override public func didMove(to view: SKView) {
        setupScene()
    }
    
    func setupScene() {
        self.backgroundColor = .white
        
        iPhone.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        self.iPhone.size = CGSize(width:570, height:570)
        iPhone.zPosition = 1
        self.addChild(self.iPhone)
        
        iPhoneempty.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        self.iPhoneempty.size = CGSize(width:570, height:570)
        iPhoneempty.alpha = 0
        iPhoneempty.zPosition = 2
        
        displayLabel.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        displayLabel.fontColor = .black
        displayLabel.numberOfLines = 3
        displayLabel.fontSize = 35
        displayLabel.zPosition = 2
        displayLabel.horizontalAlignmentMode = .center
        displayLabel.verticalAlignmentMode = .center
        
        self.addChild(self.displayLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.fadeOutApps() })
        
        displayText()
        createBG()
    }

    func displayText() {
        let outSequence = SKAction.sequence([wait, fadeOut])
        displayLabel.run(outSequence, completion: {
            self.displayLabel.text = self.splashMessages[self.splashCount]
            self.displayLabel.run(self.fadeIn, completion:{
                self.speak(message: self.splashMessages[self.splashCount])
                self.displayLabel.run(outSequence)
                self.splashCount += 1
                if self.splashCount < self.splashMessages.count {
                    self.displayText()
                } else if self.splashCount == self.splashMessages.count {
                    self.displayLabel.run(outSequence, completion: self.moveToScene)
                }
            })
        })
    }
    
    func createBG() {
        bg = UIBezierPath(roundedRect: CGRect(x: 15, y: 15, width: 570, height: 540), cornerRadius: 8)
        let bgSprite = SKShapeNode()
        bgSprite.path = bg.cgPath
        bgSprite.fillColor = UIColor(red: 0.92, green: 0.93, blue: 0.93, alpha: 1.00)
        bgSprite.zPosition = 0
        addChild(bgSprite)
    }
    
    func fadeOutApps() {
        let outSequence = SKAction.sequence([fadeOut, removeNode])
        self.addChild(iPhoneempty)
        let soundURL = Bundle.main.url(forResource: "pop", withExtension: "mp3")
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        self.audioPlayer.play()
        iPhoneempty.run(fadeIn, completion:{
            self.iPhone.run(outSequence)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { self.iPhoneempty.run(outSequence) })
        })
        
    }
    
    //creates the synthesiser
    func speak(message:String) {
        speechSynth?.stopSpeaking(at: AVSpeechBoundary.immediate);
        let utterance = AVSpeechUtterance(string: message)
        utterance.rate = 0.5
        speechSynth?.speak(utterance)
    }
    
    func moveToScene() {
        let reveal = SKTransition.flipHorizontal(withDuration:1)
        let newScene = InstructionScene(size: CGSize(width:600, height:570))
        newScene.scaleMode = .aspectFit
        self.view?.presentScene(newScene, transition: reveal)
    }
}

