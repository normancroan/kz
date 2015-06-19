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
//    var maxJump:CGFloat = 7.2//12 was before dt, need to modify by 1.6ish//18
    var maxJump:CGFloat = 23
    var attackAmount:CGFloat = 0
    var maxAttack:CGFloat = 8
    
    
    var slowWalkAction:SKAction?
    var walkAction:SKAction?
    var idleAction:SKAction?
    var attackAction:SKAction?
    var jumpAction:SKAction?
    
//    var maxSpeed:CGFloat = 1.9//3.1 was before DT, need to modify by 1.6ish
    var maxSpeed:CGFloat = 7//3.1 was before DT, need to modify by 1.6ish

    var isAttacking:Bool = false
    var isJumping:Bool = false
    var isRunning:Bool = false
    var doubleJumpAlreadyUsed:Bool = false
    var walkingSlow:Bool = false
    var isFalling:Bool = false


    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NScoding not supported")
    }
    
    init (imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color:nil, size: imageTexture.size() )
        
        //resizing the physics rectangle to align with feet
        var rect:CGRect = CGRectMake(position.x, position.y, imageTexture.size().width / 2.8, imageTexture.size().height * 0.6)
        var anchor:CGPoint = CGPointMake(position.x - 12.5, position.y)
        
        //creating physics body with above values to align with feet
        var rectBody:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: rect.size, center: CGPoint(x: anchor.x, y: anchor.y))
        var body2:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 2)
        
        //using this circle body for now, perhaps extend by adding another body on top to collide with head
//        var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 3, center: CGPointMake(-15, -35))
        var body3:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().height / 10, center: CGPointMake(0, -45))
        
        var frontFoot:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().height / 10, center: CGPointMake(0, -45))
        var backFoot:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().height / 6, center: CGPointMake(0, -35))
        var rectBodyThin:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: rect.size, center: CGPointMake(-12.5, -18))
        
        var body:SKPhysicsBody = SKPhysicsBody(bodies: [frontFoot, rectBodyThin])
        
        
        //dynamic required for gravity to work
        body.dynamic = true
        body.restitution = 0
        body.affectedByGravity = true
        body.allowsRotation = false
        //body.categoryBitMask = PhysicsCategory.Player
        body.categoryBitMask = SKACategoryPlayer
        //body.collisionBitMask = PhysicsCategory.Floor | PhysicsCategory.Boundary
        body.collisionBitMask = SKACategoryFloor | SKACategoryWall
        //body.contactTestBitMask = PhysicsCategory.All
        body.contactTestBitMask = SKACategoryFloor
        body.usesPreciseCollisionDetection = true
        
        self.physicsBody = body
        
        //setUpAttackAction()
        setUpIdleAction()
        setUpJumpAction()
        setUpWalkAnimation()
        
        self.runAction(idleAction)
    }
    

    func update(dt: CGFloat) {

        
        //capped the delta time to try and correct lag cheating
        var dtOpen: CGFloat = dt * 100
        if dtOpen > 2.5 {
            dtOpen = 2.5
        }
        
//        self.position = CGPointMake(self.position.x + (playerSpeedX * (dt * 100)), self.position.y + (jumpAmount * dtOpen))
        
        self.position = CGPointMake(self.position.x + playerSpeedX, self.position.y + jumpAmount)
        
//        if (self.position.y < -300) {
//            
//            self.position = CGPointMake( 100, 300)
//            
//        }
        
        if physicsBody?.velocity.dy > 1000 {
            physicsBody?.velocity.dy = 1000
        }
        
        if physicsBody?.velocity.dy < -1000 {
            physicsBody?.velocity.dy = -1000
        }
        
        if physicsBody?.velocity.dx > 75 {
            physicsBody?.velocity.dx = 75
        }
        
        if physicsBody?.velocity.dx < -75 {
            physicsBody?.velocity.dx = -75
        }
        
        
        
        
       // println(physicsBody?.velocity.dx)
    }
    
    
    func setUpWalkAnimation() {
        
        let atlas = SKTextureAtlas (named: "Walk")
        
        var array = [String]()
        
        //or setup an array with exactly the sequential frames start from 0 and going to 23
        for var i=0; i <= 23; i++ {
            
            let nameString = String(format: "Walk%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++ ) {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/60, resize: true , restore:false )
        walkAction =  SKAction.repeatActionForever(atlasAnimation)
        
        let atlasAnimation2 = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/20, resize: true , restore:false )
        slowWalkAction =  SKAction.repeatActionForever(atlasAnimation2)
        
    }
    func setUpIdleAction() {
        
        let atlas = SKTextureAtlas (named: "Idle")
        
        // setup an array with frames in any order you want.
        //let array:[String] = ["Ship1", "Ship2", "Ship3", "Ship4", "Ship5", "Ship6"]
        
        var array = [String]()
        
        //or setup an array with exactly the sequential frames start from 1 and going to 12
        for var i=0; i <= 23; i++ {
            
            let nameString = String(format: "Idle%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++ ) {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/15, resize: true , restore:false )
        idleAction =  SKAction.repeatActionForever(atlasAnimation)
        
    }
    
    func setUpAttackAction() {
        
        let atlas = SKTextureAtlas (named: "Attack")
        
        // setup an array with frames in any order you want.
        //let array:[String] = ["Ship1", "Ship2", "Ship3", "Ship4", "Ship5", "Ship6"]
        
        var array = [String]()
        
        //or setup an array with exactly the sequential frames start from 1 and going to 12
        for var i=0; i <= 15; i++ {
            
            let nameString = String(format: "Attack%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++ ) {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/60, resize: true  , restore:false )
        let performSelector:SKAction = SKAction.runBlock(self.walkOrStop)
        attackAction =  SKAction.sequence([atlasAnimation, performSelector])
        
    }
    
    func setUpJumpAction() {
        
        let atlas = SKTextureAtlas (named: "Jump")
        
        // setup an array with frames in any order you want.
        //let array:[String] = ["Ship1", "Ship2", "Ship3", "Ship4", "Ship5", "Ship6"]
        
        var array = [String]()
        
        //or setup an array with exactly the sequential frames start from 1 and going to 12
        for var i=0; i <= 23; i++ {
            
            let nameString = String(format: "Jump%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++ ) {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/60, resize: true  , restore:false )
        let performSelector:SKAction = SKAction.runBlock(self.walkOrStop)
        jumpAction =  SKAction.sequence([atlasAnimation, performSelector])
        
    }
    
    
    func adjustXSpeedAndScale () {
        
        if (playerSpeedX > maxSpeed) {
            
            playerSpeedX = maxSpeed
        } else if (playerSpeedX < -maxSpeed) {
            
            playerSpeedX = -maxSpeed
        }
        
        
        
        if ( abs(playerSpeedX) < abs(maxSpeed / 2) && isJumping == false && isAttacking == false && walkingSlow == false ) {
            
            walkingSlow = true
            self.runAction( slowWalkAction)
            
        } else if ( abs(playerSpeedX) > abs(maxSpeed / 2) && isJumping == false && isAttacking == false && walkingSlow == true) {
            
            walkingSlow = false
            self.runAction( walkAction)
            
        }
        
        
        
        
        
        
        if ( playerSpeedX > 0 ){
            
            self.xScale = 0.7
        } else {
            
            self.xScale = -0.7
        }
        
        
        
        
        
    }
    
    
    
    
    
    func walkOrStop() {
        
        if ( playerSpeedX != 0) {
            
            startWalk()
        } else {
            
            stopWalk()
        }
    }

    
    func startWalk() {
        
        
        if (abs(playerSpeedX) < abs(maxSpeed / 2) && walkingSlow == false  ) {
            
            walkingSlow = true
            self.runAction(slowWalkAction)
            //println("should be walking slow")
            
        } else if (abs(playerSpeedX) > abs(maxSpeed / 2)  && walkingSlow == true ) {
            
            walkingSlow = false
            self.runAction(walkAction)
            //println("should be walking")
            isRunning = true
            
        } else {
            walkingSlow = false
            self.runAction(walkAction)
            //println("should be walking")
            isRunning = true
        }
        
        
    }
    func stopWalk() {
        
        self.runAction(idleAction)
        //println("idling")
        isRunning = false
        
    }
    func attack() {
        
        isAttacking = true
        
        self.runAction(attackAction)
        
        
        if (self.xScale == 1) {
            
            // facing right
            
            attackAmount = maxAttack
            
        } else {
            
            // facing left
            attackAmount = -maxAttack
            
        }
        
        
        let callAgain:SKAction = SKAction.runBlock( taperSpeed)
        let wait:SKAction = SKAction.waitForDuration(1/60)
        let seq:SKAction = SKAction.sequence([wait, callAgain])
        let repeat:SKAction = SKAction.repeatAction(seq, count: 20)
        let stop:SKAction = SKAction.runBlock( stopAttack)
        let seq2:SKAction = SKAction.sequence([repeat, stop])
        
        self.runAction(seq2)
        
        
    }
    
    func taperSpeed() {
        
        attackAmount = attackAmount * 0.9
        
        
    }
    
    func stopAttack() {
        
        println( "attack stopped")
        
        isAttacking = false
        attackAmount = 0
        
    }
    
    func setFalling(falling: Bool) {
        if falling {
            isFalling = true
            //println("falling")
        } else {
            isFalling = false
            //println("not falling")
        }
    }
    
    
    func jump() {
        
        if !isFalling {
        if (isJumping == false) {
            
            self.runAction(jumpAction)
            
            
            isJumping = true
            
            
            jumpAmount = maxJump
            
            let callAgain:SKAction = SKAction.runBlock( taperJump)
            let wait:SKAction = SKAction.waitForDuration(2/60)
            let seq:SKAction = SKAction.sequence([wait, callAgain])
            let repeat:SKAction = SKAction.repeatAction(seq, count: 5)
            let stop:SKAction = SKAction.runBlock( stopJump)
            let seq2:SKAction = SKAction.sequence([repeat, stop])
            
            self.runAction(seq2)
        }
        
        //removed double jumping
//        } else if ( isJumping == true && doubleJumpAlreadyUsed == false) {
//            
//            doubleJumpAlreadyUsed = true
//            jumpAmount = maxJump * 1.5
//            
//            
//        }
        
        }
    }
    
    func taperJump() {
        
        jumpAmount = jumpAmount * 0.7
    }
    
    func stopJump() {
        
        doubleJumpAlreadyUsed = false
        isJumping = false
        jumpAmount = 0
        
    }
    
    func stopJumpFromPlatform() {
        
        
        if ( isJumping == true) {
            
            
            
            println( "stopping jump early")
            stopJump()
            walkOrStop()
            
        }
        
    }
}