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
    
    
    var playerSpeedX:CGFloat = 0
    var playerSpeedY:CGFloat = 0
    
    
    var jumpAmount:CGFloat = 0
    var maxJump:CGFloat = 22
    
    
    var attackAmount:CGFloat = 0
    var maxAttack:CGFloat = 8
    
    
    var slowWalkAction:SKAction?
    var walkAction:SKAction?
    var idleAction:SKAction?
    var attackAction:SKAction?
    var jumpAction:SKAction?
    
    var maxSpeed:CGFloat = 5
    
    
    var isAttacking:Bool = false
    var isJumping:Bool = false
    var doubleJumpAlreadyUsed:Bool = false
    var walkingSlow:Bool = false

    
    
    
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
        var rectBody:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: rect.size, center: CGPoint(x: anchor.x, y: anchor.y))
        var body2:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 2)
        
        //using this circle body for now, perhaps extend by adding another body on top to collide with head
        var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 3, center: CGPointMake(-15, -35))
        
        
        //dynamic required for gravity to work
        body.dynamic = true
        body.restitution = 0
        body.affectedByGravity = true
        body.allowsRotation = false
        body.categoryBitMask = PhysicsCategory.Player
        //body.collisionBitMask = PhysicsCategory.Floor
        body.contactTestBitMask = PhysicsCategory.Floor
        
        self.physicsBody = body
    }
}