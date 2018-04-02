import Foundation
import AVFoundation
import SpriteKit

public class Notes: SKScene {
    
    let notes = SKSpriteNode(imageNamed: "notes.png")
    let beginNotes = SKSpriteNode(imageNamed: "BeginButton2.png")
    let beginWWDC = SKSpriteNode(imageNamed: "startwwdc.png")
    let stage = SKSpriteNode(imageNamed: "WWDC.png")
    let wallpaper = SKSpriteNode(imageNamed: "wwdc18cc.png")
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
    let removeNode = SKAction.removeFromParent()
    let wait = SKAction.wait(forDuration: 3.5)
    let finishLabel = SKLabelNode(fontNamed: "San Francisco")
    var splashCount = 0
    var bg = UIBezierPath()
    var audioPlayer = AVAudioPlayer()
    var speechSynth:AVSpeechSynthesizer? = AVSpeechSynthesizer()
    let splashMessages = ["Congratulations,\nyou got Craig here\njust in time for the keynote", "However, Craig is a\nlittle nervous\nso maybe you could help\nhim revise his demo notes"]
    
    override public func didMove(to view: SKView) {
        setupScene()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { self.fantasticSpeech() })
    }
    
    func setupScene() {
        self.backgroundColor = .white
        
        finishLabel.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        finishLabel.fontColor = .black
        finishLabel.numberOfLines = 3
        finishLabel.fontSize = 35
        finishLabel.alpha = 0
        finishLabel.zPosition = 1
        finishLabel.horizontalAlignmentMode = .center
        finishLabel.verticalAlignmentMode = .center
        self.addChild(self.finishLabel)
        displayText()
        createBG()
        
        notes.position = CGPoint(x: self.frame.midX, y:self.frame.midY + 30)
        self.notes.size = CGSize(width:600, height:480)
        notes.alpha = 0
        notes.zPosition = 1
        
        wallpaper.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        notes.zPosition = 1
        self.addChild(wallpaper)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { self.removeWallpaper() })
        
        beginNotes.position = CGPoint(x: self.frame.midX, y: 100)
        beginNotes.alpha = 0
        beginNotes.zPosition = 2
        
        beginWWDC.position = CGPoint(x: self.frame.midX, y: 60)
        beginWWDC.alpha = 0
        beginWWDC.zPosition = 1
        
        stage.position = CGPoint(x: self.frame.midX ,y: self.frame.midX)
        stage.alpha = 0
        stage.zPosition = 1
    }
    
    func createBG() {
        bg = UIBezierPath(roundedRect: CGRect(x: 15, y: 15, width: 570, height: 540), cornerRadius: 8)
        let bgSprite = SKShapeNode()
        bgSprite.path = bg.cgPath
        bgSprite.fillColor = UIColor(red: 0.92, green: 0.93, blue: 0.93, alpha: 1.00)
        bgSprite.zPosition = 0
        addChild(bgSprite)
    }
    
    func fantasticSpeech() {
        let soundURL = Bundle.main.url(forResource: "fantastic", withExtension: "mp3")
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        self.audioPlayer.play()
    }
    
    func displayText() {
        let outSequence = SKAction.sequence([wait, fadeOut])
        let inSequence = SKAction.sequence([wait, fadeIn])
        finishLabel.run(outSequence, completion: {
            self.finishLabel.text = self.splashMessages[self.splashCount]
            self.finishLabel.run(self.fadeIn, completion:{
                self.speak(message: self.splashMessages[self.splashCount])
                self.splashCount += 1
                if self.splashCount < self.splashMessages.count {
                    self.finishLabel.run(outSequence)
                    self.displayText()
                } else if self.splashCount == self.splashMessages.count {
                    self.addChild(self.beginNotes)
                    self.beginNotes.run(inSequence)
                }
            })
        })
    }
    
    //creates the synthesiser
    func speak(message:String) {
        speechSynth?.stopSpeaking(at: AVSpeechBoundary.immediate);
        let utterance = AVSpeechUtterance(string: message)
        utterance.rate = 0.5
        speechSynth?.speak(utterance)
    }
    
    func removeButton() {
        let removeSequence = SKAction.sequence([fadeOut, removeNode])
        finishLabel.run(removeSequence)
        beginNotes.run(removeSequence, completion: showNotes)
    }
    
    func removeWallpaper() {
        let removeSequence = SKAction.sequence([fadeOut, removeNode])
        wallpaper.run(removeSequence)
    }
    
    func showNotes() {
        self.addChild(self.notes)
        self.notes.run(self.fadeIn)
        let soundURL = Bundle.main.url(forResource: "dontwantthat", withExtension: "mp3")
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        self.audioPlayer.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.showStartButton() })
    }
    
    func showStartButton() {
        self.addChild(self.beginWWDC)
        beginWWDC.run(self.fadeIn)
    }
    
    func moveToScene() {
        let reveal = SKTransition.fade(withDuration:1.5)
        let newScene = StartWWDC(size: CGSize(width:600, height:570))
        newScene.scaleMode = .aspectFit
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        // beginNotes button is pressed
        if self.beginNotes.contains(touchLocation) {
            removeButton()
        }
        
        // beginWWDC button is pressed
        if self.beginWWDC.contains(touchLocation) {
            moveToScene()
        }
    }
}

