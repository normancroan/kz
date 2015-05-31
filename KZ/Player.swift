//
//  Player.swift
//  KZ
//
//  Created by Norman Croan on 5/31/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NScoding not supported")
    }
    
    init (imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color:nil, size: imageTexture.size() )
        
        //resizing the physics rectangle to align with feet
        var rect:CGRect = CGRectMake(position.x, position.y, imageTexture.size().width / 2.8, imageTexture.size().height)
        var anchor:CGPoint = CGPointMake(position.x - 12.5, position.y)
        
        //creating physics body with above values to align with feet
        var body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: rect.size, center: CGPoint(x: anchor.x, y: anchor.y))
        
        //dynamic required for gravity to work
        body.dynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.categoryBitMask = PhysicsCategory.Player
        //body.collisionBitMask = PhysicsCategory.Floor
        body.contactTestBitMask = PhysicsCategory.Floor
        
        self.physicsBody = body
    }
}