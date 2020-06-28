//
//  GameOverScene.swift
//  Game-Starter-Empty
//
//  Created by Angelina Olmedo on 6/25/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var score: Int! = 0
    var gameOverLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    
    var gameScene: GameScene! {
        didSet {
            self.size = gameScene.size
        }
    }
      
    override func sceneDidLoad() {

    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        if gameScene == nil {
            return
        }
        
        // bg
        let bg = SKSpriteNode(color: SKColor.red,
                                size: CGSize(width: self.size.width, height: self.size.height))
        bg.texture = SKTexture(imageNamed: "bg")
        // set sprite's position
        bg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bg.zPosition = -1
        // add sprite as a child of a scene
        self.addChild(bg)
        print(bg.debugDescription)
        
        // game over label
        gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontName = "HelveticaNeue-Bold"
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gameOverLabel.zPosition = 1
        self.addChild(self.gameOverLabel)
        
        // score label
        scoreLabel = SKLabelNode(text: "\(self.score!)")
        scoreLabel.fontName = "HelveticaNeue"
        scoreLabel.name = "Score Label"
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height - 250)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
//        print(self.scoreLabel.position)
    }
    
    override func didMove(to view: SKView) {
        self.scoreLabel.text = "Your final score: \(self.score!)"
//        print(self.scoreLabel.debugDescription)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
        
    
    // MARK: Touches
    
    func touchUp(atPoint pos : CGPoint) {
        // return to game
        view?.presentScene(gameScene, transition: gameScene.crossFade)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
