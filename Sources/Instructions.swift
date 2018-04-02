import Foundation
import AVFoundation
import SpriteKit

public class InstructionScene: SKScene {
    
    let instructionSheet = SKSpriteNode(imageNamed: "instructionsheet.png")
    let beginButton = SKSpriteNode(imageNamed: "BeginButton2.png")
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
    let wait = SKAction.wait(forDuration: 5)
    
    override public func didMove(to view: SKView) {
        setupScene()
    }
    
    func setupScene() {
        let fadeInSequence = SKAction.sequence([wait, fadeIn])
        self.backgroundColor = .white
        
        instructionSheet.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        self.instructionSheet.size = CGSize(width:600, height:570)
        self.addChild(self.instructionSheet)
        
        beginButton.position = CGPoint(x: self.frame.midX, y: 65)
        beginButton.alpha = 0
        self.addChild(self.beginButton)
        beginButton.run(fadeInSequence)
    }
    
    func moveToScene() {
        let reveal = SKTransition.flipHorizontal(withDuration:1)
        let newScene = Scene(size: CGSize(width:600, height:570))
        newScene.scaleMode = .aspectFit
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        // Move sprite up
        if self.beginButton.contains(touchLocation) {
            moveToScene()
        }
    }
}

