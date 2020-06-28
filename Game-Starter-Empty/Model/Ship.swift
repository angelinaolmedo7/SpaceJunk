//
//  Shift.swift
//  Game-Starter-Empty
//
//  Created by Angelina Olmedo on 6/11/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import Foundation
import SpriteKit

class Ship: SKSpriteNode {
    
    var vel: Double
    var sceneWidth: CGFloat
    
    init(scene: SKScene, vel: Double=150) {
        let texture = SKTexture(imageNamed: "ship")
        let size = texture.size()
        let color = UIColor.clear
        
        self.sceneWidth = scene.size.width
        self.vel = vel
        
        super.init(texture: texture, color: color, size: size)
        position = CGPoint(x: sceneWidth/2, y: 100)
        self.zPosition = 2
        self.name = "ship"
    }
    
    func getDuration(left: Bool) -> Double{
        // calculate what duration to give the SKAction to maintain a constant speed of self.vel
        let xPos = Double(self.position.x)
        if left {
            return xPos/vel
        }
        else {
            return (Double(self.sceneWidth)-xPos)/vel
        }
    }
    
    func moveShip(left: Bool) {
        if left {
            self.run(SKAction.moveTo(x: 0, duration: getDuration(left: true)))
        }
        else { // right
            self.run(SKAction.moveTo(x: self.sceneWidth, duration: getDuration(left: false)))
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
