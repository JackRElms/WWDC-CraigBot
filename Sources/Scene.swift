import Foundation
import SpriteKit
import AVFoundation
import UIKit

public class Scene : SKScene, SKPhysicsContactDelegate{
    
    //Buttons
    let up = SKSpriteNode(imageNamed: "up.png")
    let right = SKSpriteNode(imageNamed: "right.png")
    let down = SKSpriteNode(imageNamed: "down.png")
    let left = SKSpriteNode(imageNamed: "left.png")
    let gameOverSign = SKSpriteNode(imageNamed: "gameover.png")
    let winnerSign = SKSpriteNode(imageNamed: "congratulations.png")
    let restartButton = SKSpriteNode(imageNamed: "restartbutton.png")
    let nextButton = SKSpriteNode(imageNamed: "right.png")
    
    //Sprites
    let spriteBlock = SKSpriteNode(color: UIColor(red: 0.5451, green: 0.5490, blue: 0.5569, alpha: 1.00), size: CGSize(width: 25, height: 25))
    let craig = SKSpriteNode(imageNamed:"craig.png")
    
    //synthesiser to speak craig's position
    var speechSynth:AVSpeechSynthesizer? = AVSpeechSynthesizer()
    
    //Scene
    let roads = SKSpriteNode(imageNamed: "road.png")
    let windows = SKSpriteNode(imageNamed: "windows.png")
    let flag = SKSpriteNode(imageNamed: "finishflag.png")
    let billGraham = SKSpriteNode(imageNamed: "billgraham.png")
    let applePark = SKSpriteNode(imageNamed: "applepark.png")
    let waves = SKSpriteNode(imageNamed: "waves.png")
    let cableCar = SKSpriteNode(imageNamed: "cablecar.png")
    let sanFran = SKSpriteNode(imageNamed: "sanfrancity.png")
    let underCone = SKSpriteNode(imageNamed: "undercone.png")
    let lombardStreet = SKSpriteNode(imageNamed: "lombardstreet")
    let goldenGateBridge = SKSpriteNode(imageNamed: "goldengatebridge.png")
    let conventionCentre = SKSpriteNode(imageNamed: "ideatree.png")
    
    //UI cards
    let switchIcon = SKSpriteNode(imageNamed: "uiswitchcard.png")
    let sliderIcon = SKSpriteNode(imageNamed: "uislidercard.png")
    let stepperIcon = SKSpriteNode(imageNamed: "uisteppercard.png")
    let buttonIcon = SKSpriteNode(imageNamed: "uibuttoncard.png")
    
    //icons for interactive draw
    let snowmanIcon = SKSpriteNode(imageNamed: "snowman.png")
    let rainbowIcon = SKSpriteNode(imageNamed: "rainbow.png")
    let navArrow = SKSpriteNode(imageNamed: "navarrow.png")
    
    //information cards
    let switchinstructions = SKSpriteNode(imageNamed: "uiswitchinstruction.png")
    let sliderinstructions = SKSpriteNode(imageNamed: "uisliderinstruction.png")
    let stepperinstructions = SKSpriteNode(imageNamed: "uistepperinstruction.png")
    let buttoninstructions = SKSpriteNode(imageNamed: "uibuttoninstruction.png")
    var magicView: UIView?
    let confettiLayer = CAEmitterLayer()
    var audioPlayer = AVAudioPlayer()
    
    //Actions
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    let fadeOut = SKAction.fadeOut(withDuration: 1)
    let removeNode = SKAction.removeFromParent()
    let shrink = SKAction.scale(to: 0, duration: 1)
    let enlarge = SKAction.scale(to: 1, duration: 1)
    let enlargeNext = SKAction.scale(to: 2, duration: 1)
    let buttonScale = SKAction.scale(to:1.4, duration:0.1)
    let buttonScaleBack = SKAction.scale(to:1, duration:0.1)
    let wait = SKAction.wait(forDuration: 3.5)

    //UI elements
    var uISwitch: UISwitch!
    var volumeSlider: UISlider!
    var rainStepper = UIStepper()

    //CategoryBitMasks for collision detection
    struct CategoryBitMask {
        static let craigSprite: UInt32 = 1 << 0
        static let windowsBody: UInt32 = 1 << 1
        static let offPath: UInt32 = 1 << 2
        static let finish: UInt32 = 1 << 3
        static let switchBody: UInt32 = 1 << 4
        static let sliderBody: UInt32 = 1 << 5
        static let stepperBody: UInt32 = 1 << 6
        static let buttonBody: UInt32 = 1 << 7
    }
    
    override public func didMove(to view: SKView) {
        setupScene()
        playMusic()
        self.scaleMode = .aspectFit
    }
    
    public func setupScene() {
        self.roads.position = CGPoint(x:300, y:250);
        self.roads.size = CGSize(width:600, height:500)
        self.addChild(self.roads)
        roads.zPosition = 0
        
        //scene physics
        self.physicsWorld.contactDelegate = self
        let sceneBound = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = sceneBound
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.backgroundColor = .white
        
        self.addDPadArrows()
        spriteBlock.position = CGPoint(x:75, y:25)
        addChild(spriteBlock)
        spriteBlock.zPosition = 2
        spriteBlock.physicsBody = SKPhysicsBody(rectangleOf: spriteBlock.size)
        spriteBlock.physicsBody!.isDynamic = false
        
        craig.position = CGPoint(x:75, y:25)
        craig.zPosition = 3
        craig.physicsBody = SKPhysicsBody(rectangleOf: craig.size)
        craig.physicsBody!.isDynamic = false
        addChild(craig)
        
        self.windows.size = CGSize(width:40, height:40)
        let windows1 = windows.copy() as! SKSpriteNode
        windows1.name = "Block"
        windows1.physicsBody = SKPhysicsBody(rectangleOf: windows.size)
        windows1.physicsBody!.isDynamic = true
        windows1.zPosition = 1
        windows1.position = CGPoint(x:75, y:375)
        self.addChild(windows1)
        
        let windows2 = windows.copy() as! SKSpriteNode
        windows2.physicsBody = SKPhysicsBody(rectangleOf: windows.size)
        windows2.physicsBody!.isDynamic = true
        windows2.zPosition = 1
        windows2.position = CGPoint(x:275, y:175)
        self.addChild(windows2)
        
        flag.physicsBody = SKPhysicsBody(rectangleOf: flag.size)
        flag.physicsBody!.isDynamic = true
        flag.zPosition = 2
        flag.position = CGPoint(x:275, y:475)
        self.addChild(flag)
        
        switchIcon.physicsBody = SKPhysicsBody(rectangleOf: switchIcon.size)
        switchIcon.physicsBody!.isDynamic = true
        switchIcon.zPosition = 2
        switchIcon.position = CGPoint(x:275, y:125)
        addChild(switchIcon)
        
        sliderIcon.physicsBody = SKPhysicsBody(rectangleOf: sliderIcon.size)
        sliderIcon.physicsBody!.isDynamic = true
        sliderIcon.zPosition = 2
        sliderIcon.position = CGPoint(x:75, y:225)
        self.addChild(sliderIcon)
        
        stepperIcon.physicsBody = SKPhysicsBody(rectangleOf: stepperIcon.size)
        stepperIcon.physicsBody!.isDynamic = true
        stepperIcon.zPosition = 2
        stepperIcon.position = CGPoint(x:325, y:425)
        self.addChild(stepperIcon)
        
        buttonIcon.physicsBody = SKPhysicsBody(rectangleOf: buttonIcon.size)
        buttonIcon.physicsBody!.isDynamic = true
        buttonIcon.zPosition = 2
        buttonIcon.position = CGPoint(x:525, y:225)
        self.addChild(buttonIcon)
        
        billGraham.position = CGPoint(x:175, y:200)
        billGraham.zPosition = 0
        billGraham.physicsBody = SKPhysicsBody(rectangleOf: billGraham.size)
        billGraham.physicsBody!.isDynamic = true
        self.addChild(billGraham)
        
        applePark.position = CGPoint(x:400, y:325)
        applePark.zPosition = 0
        applePark.physicsBody = SKPhysicsBody(rectangleOf: applePark.size)
        applePark.physicsBody!.isDynamic = true
        self.addChild(applePark)
        
        waves.position = CGPoint(x:25, y:250)
        waves.zPosition = 0
        waves.physicsBody = SKPhysicsBody(rectangleOf: waves.size)
        waves.physicsBody!.isDynamic = true
        self.addChild(waves)
        
        cableCar.position = CGPoint(x:175, y:50)
        cableCar.zPosition = 0
        cableCar.physicsBody = SKPhysicsBody(rectangleOf: cableCar.size)
        cableCar.physicsBody!.isDynamic = true
        self.addChild(cableCar)
        
        sanFran.position = CGPoint(x:450, y:100)
        sanFran.zPosition = 0
        sanFran.physicsBody = SKPhysicsBody(rectangleOf: sanFran.size)
        sanFran.physicsBody!.isDynamic = true
        self.addChild(sanFran)
        
        underCone.position = CGPoint(x:275, y:25)
        underCone.zPosition = 0
        underCone.physicsBody = SKPhysicsBody(rectangleOf: underCone.size)
        underCone.physicsBody!.isDynamic = true
        self.addChild(underCone)
        
        lombardStreet.position = CGPoint(x:575, y:325)
        lombardStreet.zPosition = 0
        lombardStreet.physicsBody = SKPhysicsBody(rectangleOf: lombardStreet.size)
        lombardStreet.physicsBody!.isDynamic = true
        self.addChild(lombardStreet)
        
        goldenGateBridge.position = CGPoint(x:450, y:475)
        goldenGateBridge.zPosition = 0
        goldenGateBridge.physicsBody = SKPhysicsBody(rectangleOf: goldenGateBridge.size)
        goldenGateBridge.physicsBody!.isDynamic = true
        self.addChild(goldenGateBridge)
        
        conventionCentre.position = CGPoint(x:175, y:400)
        conventionCentre.zPosition = 0
        conventionCentre.physicsBody = SKPhysicsBody(rectangleOf: conventionCentre.size)
        conventionCentre.physicsBody!.isDynamic = true
        self.addChild(conventionCentre)
        
        navArrow.position = CGPoint(x:330, y:535)
        navArrow.zPosition = 5
        
        switchinstructions.alpha = 0
        switchinstructions.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        switchinstructions.zPosition = 4
        
        sliderinstructions.alpha = 0
        sliderinstructions.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        sliderinstructions.zPosition = 4
        
        stepperinstructions.alpha = 0
        stepperinstructions.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        stepperinstructions.zPosition = 4
        
        buttoninstructions.alpha = 0
        buttoninstructions.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        buttoninstructions.zPosition = 4
        
        
        //assigns bitmasks to sprites
        spriteBlock.physicsBody!.categoryBitMask = CategoryBitMask.craigSprite
        windows1.physicsBody!.categoryBitMask = CategoryBitMask.windowsBody
        windows2.physicsBody!.categoryBitMask = CategoryBitMask.windowsBody
        flag.physicsBody!.categoryBitMask = CategoryBitMask.finish
        billGraham.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        applePark.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        waves.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        cableCar.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        sanFran.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        underCone.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        lombardStreet.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        goldenGateBridge.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        conventionCentre.physicsBody!.categoryBitMask = CategoryBitMask.offPath
        switchIcon.physicsBody!.categoryBitMask = CategoryBitMask.switchBody
        sliderIcon.physicsBody!.categoryBitMask = CategoryBitMask.sliderBody
        stepperIcon.physicsBody!.categoryBitMask = CategoryBitMask.stepperBody
        buttonIcon.physicsBody!.categoryBitMask = CategoryBitMask.buttonBody
        
        //what the sprites can collide with
        spriteBlock.physicsBody!.contactTestBitMask = CategoryBitMask.windowsBody | CategoryBitMask.offPath
        windows1.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        windows2.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        flag.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        billGraham.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        applePark.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        waves.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        cableCar.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        sanFran.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        underCone.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        lombardStreet.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        goldenGateBridge.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        conventionCentre.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        switchIcon.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        sliderIcon.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        stepperIcon.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        buttonIcon.physicsBody!.contactTestBitMask = CategoryBitMask.craigSprite
        
        //sets the sprites collisions to 0
        spriteBlock.physicsBody!.collisionBitMask = 0
        windows1.physicsBody!.collisionBitMask = 0
        windows2.physicsBody!.collisionBitMask = 0
        flag.physicsBody!.collisionBitMask = 0
        billGraham.physicsBody!.collisionBitMask = 0
        applePark.physicsBody!.collisionBitMask = 0
        waves.physicsBody!.collisionBitMask = 0
        cableCar.physicsBody!.collisionBitMask = 0
        sanFran.physicsBody!.collisionBitMask = 0
        underCone.physicsBody!.collisionBitMask = 0
        lombardStreet.physicsBody!.collisionBitMask = 0
        goldenGateBridge.physicsBody!.collisionBitMask = 0
        conventionCentre.physicsBody!.collisionBitMask = 0
        switchIcon.physicsBody!.collisionBitMask = 0
        sliderIcon.physicsBody!.collisionBitMask = 0
        stepperIcon.physicsBody!.collisionBitMask = 0
        buttonIcon.physicsBody!.collisionBitMask = 0
        
        //setup volume controls
        let volumeWidth: CGFloat = 200
        let volumeHeight: CGFloat = 50
        let sliderFrame = CGRect(x: self.frame.width - volumeWidth - 18, y: 10, width: volumeWidth, height: volumeHeight)
        volumeSlider = UISlider(frame: sliderFrame)
        volumeSlider.setValue(0.5, animated: true)
        volumeSlider.maximumValueImage = UIImage(named: "volume_high")
        volumeSlider.minimumValueImage = UIImage(named: "volume_low")
        volumeSlider.setValue(0.5, animated: true)
        volumeSlider.addTarget(self, action: #selector(volumeChanged(_:)), for: .valueChanged)
        
        //setup switch
        uISwitch = UISwitch(frame: CGRect(x:55, y:18, width: 100, height:100))
        uISwitch.addTarget(self, action: #selector(self.rainbow), for: .valueChanged)
        uISwitch.isOn = false
        rainbowIcon.position = CGPoint(x:32, y:535)
        rainbowIcon.zPosition = 60
        
        //setup stepper
        rainStepper = UIStepper(frame: CGRect(x:self.frame.width - 415, y:self.frame.height - 550, width:50, height:50))
        rainStepper.minimumValue = 0
        rainStepper.maximumValue = 60
        rainStepper.stepValue = 10
        rainStepper.addTarget(self, action: #selector(self.confetti), for: .valueChanged)
        snowmanIcon.position = CGPoint(x:160, y:535)
        snowmanIcon.zPosition = 50
        
        //windows sprite move action
        let moveUp = SKAction.moveBy(x:0, y: 200, duration: 4)
        let sequence = SKAction.sequence([moveUp, moveUp.reversed()])
        windows2.run(SKAction.repeatForever(sequence), withKey:  "moving")
        dPad()
        makeInteractiveDraw()
    }
    
    func makeInteractiveDraw() {
        let interactiveDrawPath1 = UIBezierPath(roundedRect: CGRect(x: 10, y: self.frame.height - 60, width: 105, height: 50), cornerRadius: 8)
        let interactiveDraw1 = SKShapeNode()
        interactiveDraw1.path = interactiveDrawPath1.cgPath
        interactiveDraw1.fillColor = UIColor(red: 0.92, green: 0.93, blue: 0.93, alpha: 1.00)
        interactiveDraw1.zPosition = 0
        addChild(interactiveDraw1)
        
        let interactiveDrawPath2 = UIBezierPath(roundedRect: CGRect(x: 140, y: self.frame.height - 60, width: 145, height: 50), cornerRadius: 8)
        let interactiveDraw2 = SKShapeNode()
        interactiveDraw2.path = interactiveDrawPath2.cgPath
        interactiveDraw2.fillColor = UIColor(red: 0.92, green: 0.93, blue: 0.93, alpha: 1.00)
        interactiveDraw2.zPosition = 0
        addChild(interactiveDraw2)
        
        let interactiveDrawPath3 = UIBezierPath(roundedRect: CGRect(x: 310, y: self.frame.height - 60, width: 40, height: 50), cornerRadius: 8)
        let interactiveDraw3 = SKShapeNode()
        interactiveDraw3.path = interactiveDrawPath3.cgPath
        interactiveDraw3.fillColor = UIColor(red: 0.92, green: 0.93, blue: 0.93, alpha: 1.00)
        interactiveDraw3.zPosition = 0
        addChild(interactiveDraw3)
        
        let interactiveDrawPath4 = UIBezierPath(roundedRect: CGRect(x: 378, y: self.frame.height - 60, width: 210, height: 50), cornerRadius: 8)
        let interactiveDraw4 = SKShapeNode()
        interactiveDraw4.path = interactiveDrawPath4.cgPath
        interactiveDraw4.fillColor = UIColor(red: 0.92, green: 0.93, blue: 0.93, alpha: 1.00)
        interactiveDraw4.zPosition = 0
        addChild(interactiveDraw4)
    }
   
    //background music
    func playMusic() {
        let soundURL = Bundle.main.url(forResource: "soundtrack", withExtension: "m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 0.5
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    @objc func volumeChanged(_ sender: UISlider) {
        self.audioPlayer.volume = sender.value
    }

    func addDPadArrows() {
        up.alpha = 0
        self.up.position = CGPoint(x:510, y:140);
        self.up.size = CGSize(width:50, height:30)
        self.addChild(self.up)
        up.zPosition = 1
        
        right.alpha = 0
        self.right.position = CGPoint(x:560, y:90);
        self.right.size = CGSize(width:30, height:50)
        self.addChild(self.right)
        right.zPosition = 1
        
        down.alpha = 0
        self.down.position = CGPoint(x:510, y:40);
        self.down.size = CGSize(width:50, height:30)
        self.addChild(self.down)
        down.zPosition = 1
        
        left.alpha = 0
        self.left.position = CGPoint(x:460, y:90);
        self.left.size = CGSize(width:30, height:50)
        self.addChild(self.left)
        left.zPosition = 1
        
        insertArrows()
    }
    
    func dPad() {
        let circlePath = UIBezierPath(ovalIn:CGRect(x:440, y:20, width:140, height:140))
        let circleShape = SKShapeNode()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor(red: 0.04, green: 0.55, blue: 0.83, alpha: 1.00)
        addChild(circleShape)
    }
    
    //re-enables the buttons
    func enableButtonUp() {
        self.up.isUserInteractionEnabled = false
    }

    func enableButtonRight() {
        self.right.isUserInteractionEnabled = false
    }
    
    func enableButtonDown() {
        self.down.isUserInteractionEnabled = false
    }
    
    func enableButtonLeft() {
        self.left.isUserInteractionEnabled = false
    }
    
    //after the game is over
    func gameOver() {
        removeArrowsFail()
        gameOverSign.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        gameOverSign.alpha = 0
        gameOverSign.zPosition = 5
        self.addChild(gameOverSign)
        gameOverSign.run(fadeIn)
        
    }
    
    func winner() {
        removeArrowsWin()
        winnerSign.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        winnerSign.alpha = 0
        winnerSign.zPosition = 5
        self.addChild(winnerSign)
        winnerSign.run(fadeIn)
    }
    
    //Adds the arrows when game is over
    func insertArrows() {
        up.run(fadeIn)
        right.run(fadeIn)
        down.run(fadeIn)
        left.run(fadeIn)
    }
    
    //removes the arrows when game is over
    func removeArrowsFail() {
        let removeSequence = SKAction.sequence([shrink, removeNode])
        up.run(removeSequence)
        right.run(removeSequence)
        down.run(removeSequence)
        left.run(removeSequence, completion: resetAppears)
    }
    
    //removes the arrows when game is over
    func removeArrowsWin() {
        let removeSequence = SKAction.sequence([shrink, removeNode])
        up.run(removeSequence)
        self.nextButton.position = CGPoint(x:560, y:90);
        self.nextButton.size = CGSize(width:30, height:50)
        self.addChild(self.nextButton)
        right.run(removeNode)
        down.run(removeSequence)
        left.run(removeSequence, completion: nextAppears)
    }
    
    //adds the next button
    func nextAppears() {
        nextButton.run(enlargeNext)
        let nextCentre = SKAction.moveBy(x:-40, y:0, duration: 1)
        nextButton.run(nextCentre)
    }
    
    //reset button
    func resetAppears() {
        restartButton.position = CGPoint(x:510, y:90)
        restartButton.alpha = 0
        restartButton.zPosition = 4
        self.addChild(restartButton)
        restartButton.run(fadeIn)
    }
    
    //creates the synthesiser
    func speak(message:String) {
        speechSynth?.stopSpeaking(at: AVSpeechBoundary.immediate);
        let utterance = AVSpeechUtterance(string: message)
        utterance.rate = 0.4
        speechSynth?.speak(utterance)
    }

    func removeInteractiveDraw() {
        volumeSlider.removeFromSuperview()
        uISwitch.removeFromSuperview()
        rainStepper.removeFromSuperview()
        navArrow.run(removeNode)
        rainbowIcon.run(removeNode)
        snowmanIcon.run(removeNode)
    }
    
    func restartScene() {
        audioPlayer.stop()
        let newScene = Scene(size: self.size)
        let animation = SKTransition.fade(withDuration: 1.0)
        removeInteractiveDraw()
        magicView?.removeFromSuperview()
        confettiLayer.removeFromSuperlayer()
        self.view?.presentScene(newScene, transition: animation)
    }
    
    func moveToScene() {
        let reveal = SKTransition.flipHorizontal(withDuration:1)
        let newScene = Notes(size: CGSize(width:600, height:570))
        newScene.scaleMode = .aspectFit
        removeInteractiveDraw()
        magicView?.removeFromSuperview()
        confettiLayer.removeFromSuperlayer()
        self.view?.presentScene(newScene, transition: reveal)
    }

    @objc func confetti(sender: UIStepper!) {
        confettiLayer.emitterPosition = CGPoint(x: self.frame.midX, y: -100)
        confettiLayer.emitterShape = kCAEmitterLayerSurface
        confettiLayer.emitterMode = kCAEmitterLayerSurface
        let confettiParticles = CAEmitterCell()
        confettiParticles.scale = 0.6
        confettiParticles.birthRate = Float(rainStepper.value)
        confettiParticles.lifetime = 10
        confettiParticles.lifetimeRange = 2
        confettiParticles.contents = UIImage(named: "particle")?.cgImage
        confettiParticles.velocityRange = 400
        confettiParticles.emissionLongitude = .pi
        confettiParticles.yAcceleration = 200
        confettiLayer.emitterCells = [confettiParticles]
        self.view?.layer.addSublayer(confettiLayer)
    }
    
    @objc func rainbow(sender: UISwitch!) {
        let rainbowView = UIView(frame: self.frame)
        rainbowView.isUserInteractionEnabled = false
        rainbowView.alpha = 0.3
        let gradient = CAGradientLayer()
        gradient.frame = rainbowView.bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.orange.cgColor,
                           UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor,
                           UIColor(red: 75/255, green: 0, blue: 130/255, alpha: 1).cgColor,
                           UIColor.purple.cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        rainbowView.layer.insertSublayer(gradient, at: 0)
        
        if sender.isOn == true {
            self.magicView = rainbowView
            self.view?.addSubview(magicView!)
        } else if sender.isOn == false {
            gradient.removeFromSuperlayer()
            magicView?.removeFromSuperview()
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if spriteBlock.position.y < 24 {
            restartScene()
        }
        confettiLayer.birthRate = Float(rainStepper.value)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        let moveUp = SKAction.moveTo(y: spriteBlock.position.y + 50, duration: 0.15)
        let moveRight = SKAction.moveTo(x: spriteBlock.position.x + 50, duration: 0.15)
        let moveDown = SKAction.moveTo(y: spriteBlock.position.y - 50, duration: 0.15)
        let moveLeft = SKAction.moveTo(x: spriteBlock.position.x - 50, duration: 0.15)
        let scaleSequence = SKAction.sequence([buttonScale, buttonScaleBack])
        
        // Move sprite up
        if self.up.contains(touchLocation) {
            up.run(scaleSequence)
            spriteBlock.run(moveUp)
            craig.run(moveUp)
            up.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { self.enableButtonUp() })
        }
        
        // Move sprite right
        if self.right.contains(touchLocation) {
            right.run(scaleSequence)
            spriteBlock.run(moveRight)
            craig.run(moveRight)
            right.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { self.enableButtonRight() })
        }
        
        // Move sprite down
        if self.down.contains(touchLocation) {
            down.run(scaleSequence)
            spriteBlock.run(moveDown)
            craig.run(moveDown)
            down.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { self.enableButtonDown() })
        }
        
        // Move sprite left
        if self.left.contains(touchLocation) {
            left.run(scaleSequence)
            spriteBlock.run(moveLeft)
            craig.run(moveLeft)
            left.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { self.enableButtonLeft() })
        }
        
        // restarts the level
        if self.restartButton.contains(touchLocation) {
            restartScene()
        }
        
        // restarts the level
        if self.nextButton.contains(touchLocation) {
            moveToScene()
        }
        
        // restarts the level
        if self.navArrow.contains(touchLocation) {
            let nx = Double(craig.position.x).rounded(toPlaces: 2)
            let ny = Double(craig.position.y).rounded(toPlaces: 2)
            speak(message: "Craig's current position is x \(nx) and y \( ny)")
        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let outSequence = SKAction.sequence([wait, fadeOut])
        let shrinkOut = SKAction.sequence([fadeOut, removeNode])
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        //craig collides with cones
        case CategoryBitMask.craigSprite | CategoryBitMask.windowsBody:
            let soundURL = Bundle.main.url(forResource: "windowserror", withExtension: "mp3")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            }
            catch {
                print(error)
            }
            audioPlayer.play()
            spriteBlock.run(removeNode)
            gameOver()
        //craig goes off path
        case CategoryBitMask.craigSprite | CategoryBitMask.offPath:
            let soundURL = Bundle.main.url(forResource: "ohdeargod", withExtension: "mp3")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            }
            catch {
                print(error)
            }
            audioPlayer.play()
            spriteBlock.run(removeNode)
            gameOver()
        //craig goes off path
        case CategoryBitMask.craigSprite | CategoryBitMask.finish:
            let soundURL = Bundle.main.url(forResource: "success", withExtension: "mp3")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            }
            catch {
                print(error)
            }
            audioPlayer.play()
            winner()
        //craig collides with switch
        case CategoryBitMask.craigSprite | CategoryBitMask.switchBody:
            switchIcon.run(shrinkOut)
            view?.addSubview(uISwitch)
            self.addChild(rainbowIcon)
            addChild(switchinstructions)
            switchinstructions.run(fadeIn, completion: {
                self.switchinstructions.run(outSequence)
            })
        //craig collides with slider
        case CategoryBitMask.craigSprite | CategoryBitMask.sliderBody:
            sliderIcon.run(shrinkOut)
            view?.addSubview(volumeSlider)
            addChild(sliderinstructions)
            sliderinstructions.run(fadeIn, completion: {
                self.sliderinstructions.run(outSequence)
            })
        //craig collides with stepper
        case CategoryBitMask.craigSprite | CategoryBitMask.stepperBody:
            stepperIcon.run(shrinkOut)
            view?.addSubview(rainStepper)
            self.addChild(snowmanIcon)
            addChild(stepperinstructions)
            stepperinstructions.run(fadeIn, completion: {
                self.stepperinstructions.run(outSequence)
            })
        //craig collides with button
        case CategoryBitMask.craigSprite | CategoryBitMask.buttonBody:
            addChild(navArrow)
            buttonIcon.run(shrinkOut)
            addChild(buttoninstructions)
            buttoninstructions.run(fadeIn, completion: {
                self.buttoninstructions.run(outSequence)
            })
        default:
            print("Collision")
        }
    }
}

// Rounds Craig's position to 1 decimal place
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

