//
//  Meteor.swift
//  Game-Starter-Empty
//
//  Created by Angelina Olmedo on 6/11/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import Foundation
import SpriteKit

enum MeteorType: String, CaseIterable {
    case small = "meteorGrey_med"
    case big = "meteorGrey_big"
    case brown = "meteorBrown_big"
}

class Meteor: SKSpriteNode {
    init() {
        let randomTexture = MeteorType.allCases.randomElement()!
        let texture = SKTexture(imageNamed: randomTexture.rawValue)
        let size = texture.size()
        let color = UIColor.clear
        
        super.init(texture: texture, color: color, size: size)
        self.zPosition = 2
        self.name = "meteor"
    }
    
    convenience init(scene: SKScene) {
        self.init()
//        self.position = CGPoint(x: scene.size.width/3, y: scene.size.height + 100)
        self.setRandomStartingPos(scene: scene)
    }
    
    func setRandomStartingPos(scene: SKScene) {
        let xValue = CGFloat(Int.random(in: 0 ... Int(scene.size.width)))
        let yValue = scene.size.height + CGFloat(Int.random(in: 100...700))
        self.position = CGPoint(x: xValue, y: yValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
