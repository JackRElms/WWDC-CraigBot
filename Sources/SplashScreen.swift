import Foundation
import AVFoundation
import SpriteKit

public class SplashScreen: SKScene, SKPhysicsContactDelegate{
    
    let helloTitle = SKSpriteNode(imageNamed: "hello.jpg")
    let ball2 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 25, height: 25))
    let playButton = SKSpriteNode(imageNamed: "BeginButton.png")
    let person1 = SKSpriteNode(imageNamed: "person1.png")
    let person2 = SKSpriteNode(imageNamed: "person2.png")
    let circleShape1 = SKShapeNode()
    let circleShape2 = SKShapeNode()
    let fadeOut = SKAction.fadeOut(withDuration: 1)
    let removeNode = SKAction.removeFromParent()
    
    var audioPlayer = AVAudioPlayer()
    
    struct CategoryBitMask {
        static let craigSprite: UInt32 = 0b1 << 0
        static let Block: UInt32 = 0b1 << 1
    }
    
    override public func didMove(to view: SKView) {
        setupScene()
        startupSound()
        addPeople()
    }
    
    func addPeople() {
        let swervePath1 = UIBezierPath(ovalIn:CGRect(x: 80, y: 80, width: 90, height: 90))
        circleShape1.path = swervePath1.cgPath
        circleShape1.fillColor = .clear
        circleShape1.strokeColor = .clear
        addChild(circleShape1)
        let move1 = SKAction.follow(swervePath1.cgPath, asOffset: false, orientToPath: true, speed: 30)
        
        let swervePath2 = UIBezierPath(ovalIn:CGRect(x:self.frame.width - 170, y:80, width:90, height:90))
        circleShape2.path = swervePath2.cgPath
        circleShape2.fillColor = .clear
        circleShape2.strokeColor = .clear
        addChild(circleShape2)
        let move2 = SKAction.follow(swervePath2.cgPath, asOffset: false, orientToPath: true, speed: 50)
        
        self.addChild(person1)
        person1.size = CGSize(width:40, height:53.6)
        person1.position = CGPoint(x: circleShape1.position.x, y: circleShape1.position.y)
        person1.run(SKAction.repeatForever(move1))
        circleShape1.zPosition = 5
        person1.zPosition = 6
        
        self.addChild(person2)
        person2.size = CGSize(width:40, height:53.6)
        person2.position = CGPoint(x: circleShape2.position.x, y: circleShape2.position.y)
        person2.run(SKAction.repeatForever(move2))
        circleShape1.zPosition = 5
        person2.zPosition = 6
    }
    
    func setupScene() {
        self.physicsWorld.contactDelegate = self
        let sceneBound = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = sceneBound
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.backgroundColor = .white
        
        helloTitle.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        self.helloTitle.size = CGSize(width:400, height:160)
        self.addChild(self.helloTitle)
        helloTitle.zPosition = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.moveTitle() })
        helloTitle.physicsBody = SKPhysicsBody(rectangleOf: helloTitle.size)
        
        playButton.zPosition = 4
        playButton.position = CGPoint(x: self.frame.midX, y:self.frame.midY - 100)
        self.playButton.size = CGSize(width:150, height:75)
        self.addChild(self.playButton)
        playButton.alpha = 0
        playButton.physicsBody = SKPhysicsBody(rectangleOf: playButton.size)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { self.showButton() })
    }
    
    func startupSound() {
        let soundURL = Bundle.main.url(forResource: "macstartup", withExtension: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    func moveTitle() {
        let moveUp = SKAction.moveTo(y: helloTitle.position.y + 100, duration: 1)
        helloTitle.run(moveUp)
    }
    
    func showButton() {
        let appear = SKAction.fadeAlpha(to: 1, duration: 1)
        playButton.run(appear)
    }
    
    func moveToScene() {
        let reveal = SKTransition.flipHorizontal(withDuration:1.5)
        let newScene = Intro(size: CGSize(width:600, height:570))
        newScene.scaleMode = .aspectFit
        self.view?.presentScene(newScene, transition: reveal)
    }
    
    func removePeople() {
        let removeSequence = SKAction.sequence([fadeOut, removeNode])
        circleShape1.run(removeSequence)
        circleShape2.run(removeSequence)
        person1.run(removeSequence)
        person2.run(removeSequence)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if self.playButton.contains(touchLocation) {
            physicsWorld.gravity = CGVector.init(dx: 0, dy: -2)
            let soundURL = Bundle.main.url(forResource: "success", withExtension: "mp3")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            }
            catch {
                print(error)
            }
            audioPlayer.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { self.moveToScene() })
            removePeople()
        }
    }
}
