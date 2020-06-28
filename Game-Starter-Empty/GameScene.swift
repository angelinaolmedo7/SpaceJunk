//
//  GameScene.swift
//  Game-Starter-Empty
//
//  Created by mitchell hudson on 9/13/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var score: Int! = 0
    var scoreLabel: SKLabelNode!
    
    var spaceship: Ship!
    var meteors: [Meteor]! = []
    var debris: [Debris]! = []
    
    var particles: SKEmitterNode!
        
    // MARK: Global Actions
    var moveToBottom : SKAction!
    var removeAction : SKAction!
    var rotateAction : SKAction!
    var sequenceAction : SKAction!
    var repeatAction : SKAction!
    var groupAction : SKAction!
    var repeatMusic : SKAction!
    
    let crossFade = SKTransition.crossFade(withDuration: 0.5)
    let gameOverScene = GameOverScene()
    
    let soundBGLoop = SKAction.playSoundFileNamed("SynthBassline.wav", waitForCompletion: true)
    let soundCrash = SKAction.playSoundFileNamed("Crash.wav", waitForCompletion: false)
    
      
    override func sceneDidLoad() {
        
        gameOverScene.scaleMode = .fill
        gameOverScene.gameScene = self
        
        // bg
        let bg = SKSpriteNode(color: SKColor.red,
                                size: CGSize(width: self.size.width, height: self.size.height))
        bg.texture = SKTexture(imageNamed: "bg")
        // set sprite's position
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bg.zPosition = 0
        // add sprite as a child of a scene
        self.addChild(bg)
        
        // score label
        scoreLabel = SKLabelNode(text: "\(self.score!)")
        scoreLabel.fontName = "HelveticaNeue-Bold"
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - 75)
        scoreLabel.zPosition = 10
        self.addChild(scoreLabel)
        
        // actions
        setGlobalActions()
        
        // ship
        spaceship = Ship(scene: self)
        self.addChild(spaceship)
        
        particles = SKEmitterNode(fileNamed: "Fire.sks")!
        particles.position = spaceship.position
        addChild(particles)
        spaceship.particles = particles
        
    }
    
    func setGlobalActions() {
        moveToBottom = SKAction.moveTo(y: -300, duration: 7)
        removeAction = SKAction.removeFromParent()
        rotateAction = SKAction.rotate(byAngle: 2, duration: 1)
        sequenceAction = SKAction.sequence([moveToBottom, removeAction])
        repeatAction = SKAction.repeatForever(rotateAction)
        groupAction = SKAction.group([sequenceAction, repeatAction])
        
        repeatMusic = SKAction.repeatForever(soundBGLoop)
    }
  
    override func didMove(to view: SKView) {
        // Called when the scene has been displayed
        self.score = 0
        self.updateScoreLabel()
        
        spaceship.resetShip()
        
        // music
        
        self.removeAllActions()
        self.run(repeatMusic)
    }
    
  
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.updateObjects()
    }
    
    func updateObjects() {
        // I want to maintain 3 active debris and 2 active meteors
        
        // Update lists
        self.debris = []
        self.enumerateChildNodes(withName: "//debris") { node, stop  in
            self.debris.append(node as! Debris)
            
            if node.frame.intersects(self.spaceship.frame) {
                self.debrisCollision()
                node.run(self.removeAction)
            }
        }
        
        self.meteors = []
        self.enumerateChildNodes(withName: "//meteor") { node, stop  in
            self.meteors.append(node as! Meteor)
            
            if node.frame.intersects(self.spaceship.frame) {
                self.meteorCollision()
                node.run(self.removeAction)
            }
        }
        
        // Update debris
        if self.debris.count < 3 {
            self.spawnNewDebris()
        }
        
        // Update meteors
        if self.meteors.count < 2 {
            self.spawnNewMeteor()
        }
    }
    
    func meteorCollision() {
//        print("DEAD")
        self.run(soundCrash)
        gameOverScene.score = self.score
        self.score = 0
        self.cleanUpObjects()
        view?.presentScene(gameOverScene, transition: crossFade)
    }
    
    func debrisCollision() {
        self.score += 1
        self.updateScoreLabel()
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(self.score!)"
    }
    
    func spawnNewDebris() {
//        print("new debris. now there are \(self.debris.count + 1) debris.")
        
        let junk = Debris(scene: self)
        self.addChild(junk)
        
        junk.run(groupAction)
    }
    
    func spawnNewMeteor() {
//        print("new meteor. now there are \(self.meteors.count) meteors.")
        
        let meteor = Meteor(scene: self)
        self.addChild(meteor)
        
        meteor.run(groupAction)
    }
    
    func cleanUpObjects() {
        // remove all debris and meteors
        self.enumerateChildNodes(withName: "//meteor") { node, stop  in
            node.run(self.removeAction)
        }
        self.enumerateChildNodes(withName: "//debris") { node, stop  in
            node.run(self.removeAction)
        }
        
        // stop music
//        self.removeAllActions()
    }
    
    
    // MARK: Touches
    
    func touchDown(atPoint pos : CGPoint) {
        if pos.x < self.size.width/2 { // left
            spaceship.moveShip(left: true)
        }
        else { // right
            spaceship.moveShip(left: false)
        }
    }
    
    
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        spaceship.removeAllActions()
        particles.removeAllActions()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
