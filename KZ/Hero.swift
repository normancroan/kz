//
//  Hero.swift
//  KZ
//
//  Created by Norman Croan on 5/31/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import Foundation
import SpriteKit

class Hero: SKSpriteNode {
    
    //MARK: Properties
    //setup the variables to be modified by actionName
    var atlasName = ""
    var animationPrefix = ""
    var animationStart = 0
    var animationStop = 0
    var frameSpeed = 15
    
    var playerSpeedX:CGFloat = 0
    var playerSpeedY:CGFloat = 0
    
    
    var jumpAmount:CGFloat = 0
    var maxJump:CGFloat = 23
    var attackAmount:CGFloat = 0
    var maxAttack:CGFloat = 8
    
    
    var slowWalkAction:SKAction?
    var walkAction:SKAction?
    var runAction:SKAction?
    var idleAction:SKAction?
    var attackAction:SKAction?
    var jumpAction:SKAction?
    var jumpSound:SKAction?
    var jumpAttackAction:SKAction?
    var fallAction:SKAction?
    var flipAction:SKAction?
    
    var maxSpeed:CGFloat = 9
    
    var isAttacking:Bool = false
    var isJumping:Bool = false
    var isRunning:Bool = false
    var doubleJumpAlreadyUsed:Bool = false
    var walkingSlow:Bool = false
    var isFalling:Bool = false
    var isRising:Bool = false
    
    //MARK: Init
    required init(coder aDecoder: NSCoder) {
        fatalError("NScoding not supported")
    }
    
    init (imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color:nil, size: imageTexture.size() )
        
        //resizing the physics rectangle to align with feet
        var rect:CGRect = CGRectMake(position.x, position.y, imageTexture.size().width / 2, imageTexture.size().height - (imageTexture.size().height / 2))
        var anchor:CGPoint = CGPointMake(position.x - 12.5, position.y)
        
        //creating physics body with above values to align with feet
        var frontFoot:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().height / 5, center: CGPointMake(0, -95))
        var rectBodyThin:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: rect.size, center: CGPointMake(-12.5, -18))
        //var body:SKPhysicsBody = SKPhysicsBody(bodies: [frontFoot, rectBodyThin])
        
        //lets try this again, too convoluted above
        let bodyRectangleBase = CGRectMake(position.x, position.y, imageTexture.size().width / 2.5, imageTexture.size().height - (imageTexture.size().height / 1.5))
            
        var bodyRectangle:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: bodyRectangleBase.size)
        
        var bodyFrontFoot:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().height / 6, center: CGPointMake(0, -45))
        
        //var body:SKPhysicsBody = SKPhysicsBody(bodies: [bodyFrontFoot, bodyRectangle])
        
        //just rectangle body
        var fullBodyRectangle = CGRectMake(position.x, position.y, imageTexture.size().width / 1.7, imageTexture.size().height / 1.25)
        
        var body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: fullBodyRectangle.size, center: CGPointMake(0, -13))
        
        
        //dynamic required for gravity to work
        body.dynamic = true
        //body.restitution = 0
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
        
        //deprecated
        //setUpAttackAction()
        //setUpIdleAction()
        //setUpJumpAction()
        //setUpWalkAnimation()
        
        setupAction("idle", characterName: "cat")
        //setupAction("walk", characterName: "cat")
        setupAction("run", characterName: "cat")
        setupAction("jump", characterName: "cat")
        setupAction("fall", characterName: "cat")
        setupAction("flip", characterName: "cat")
        //setupAction("jump attack", characterName: "cat")
        
        self.runAction(idleAction)
    }
    
    //MARK: Loop
    func update(dt: CGFloat) {
        
        
        //capped the delta time to try and correct lag cheating
        var dtOpen: CGFloat = dt * 100
        if dtOpen > 2.5 {
            dtOpen = 2.5
        }
        
        //        self.position = CGPointMake(self.position.x + (playerSpeedX * (dt * 100)), self.position.y + (jumpAmount * dtOpen))
        
        self.position = CGPointMake(self.position.x + playerSpeedX, self.position.y + jumpAmount)
        
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
    
    //MARK: Methods
    func setupAction(actionName: String, characterName: String) {
        
        //choose atlas based on character name
        if characterName == "executioner" {
            atlasName = "executioner_animations"
            //println(atlasName)
        } else if characterName == "cat" {
            atlasName = "cat_player"
        }
        
        //modify the variables
        if actionName == "idle" {
            animationPrefix = "idle_"
            animationStart = 0
            animationStop = 120
            frameSpeed = 30
        } else if actionName == "walk" {
            animationPrefix = "walk_"
            animationStart = 0
            animationStop = 9
            frameSpeed = 30
        } else if actionName == "run" {
            animationPrefix = "run_"
            animationStart = 0
            animationStop = 29
            frameSpeed = 40
        } else if actionName == "jump" {
            animationPrefix = "jump_start_"
            animationStart = 0
            animationStop = 8
            frameSpeed = 30
        } else if actionName == "jump attack" {
            animationPrefix = "Jump Attack_"
            animationStart = 0
            animationStop = 15
            frameSpeed = 60
        } else if actionName == "fall" {
            animationPrefix = "jump_loop_"
            animationStart = 0
            animationStop = 16
            frameSpeed = 30
        } else if actionName == "flip" {
            animationPrefix = "flip_"
            animationStart = 0
            animationStop = 21
            frameSpeed = 30
        }

        
        //setup the animation
        let atlas = SKTextureAtlas (named: atlasName)
        var array = [String]()
        
        for var i=animationStart; i <= animationStop; i++ {
            
            let nameString = "\(animationPrefix)\(i)"
            println(nameString)
            array.append(nameString)
            
        }
        //create the array of textures used for animation
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++ ) {
            //read texture names from array created above
            let texture:SKTexture = atlas.textureNamed( array[i] )
            //add those names to the array of textures
            atlasTextures.insert(texture, atIndex:i)
        }
        
        //create the animation
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/Double(frameSpeed), resize: true , restore:false )
        //println(atlasTextures)
        
        //assign the animation to appropriate action
        if actionName == "idle" {
            idleAction  = SKAction.repeatActionForever(atlasAnimation)
        } else if actionName == "run" {
            runAction   = SKAction.repeatActionForever(atlasAnimation)
        } else if actionName == "jump" {
            let performSelector:SKAction = SKAction.runBlock(self.walkOrStop)
            jumpAction =  SKAction.sequence([atlasAnimation, performSelector])
            jumpSound = SKAction.playSoundFileNamed("jump_03.wav", waitForCompletion: false)
        } else if actionName == "jump attack" {
            jumpAttackAction = SKAction.repeatActionForever(atlasAnimation)
        } else if actionName == "walk" {
            walkAction = SKAction.repeatActionForever(atlasAnimation)
        } else if actionName == "fall" {
            fallAction = SKAction.repeatActionForever(atlasAnimation)
        } else if actionName == "flip" {
            let performSelector:SKAction = SKAction.runBlock(self.walkOrStop)
            flipAction =  SKAction.sequence([atlasAnimation, performSelector])
        }
    }
    
    func adjustXSpeedAndScale () {
        
        if (playerSpeedX > maxSpeed) {
            
            playerSpeedX = maxSpeed
        } else if (playerSpeedX < -maxSpeed) {
            
            playerSpeedX = -maxSpeed
        }
        
        
        
        if ( abs(playerSpeedX) < abs(maxSpeed / 2) && isJumping == false && isAttacking == false && walkingSlow == false ) {
            
            walkingSlow = true
            println("started walking slow from setspeed")
            self.runAction( slowWalkAction!, withKey: "walk")
            
        } else if ( abs(playerSpeedX) > abs(maxSpeed / 2) && isJumping == false && isAttacking == false && walkingSlow == true) {
            
            walkingSlow = false
            if actionForKey("walk") == nil {
                println("started walking from setspeed")
              self.runAction( walkAction!, withKey: "walk")
            }
        }
        
        
        
        
        
        
        if ( playerSpeedX > 0 ){
            
            self.xScale = 0.7//1//0.4
        } else {
            
            self.xScale = -0.7//-1//-0.4
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
        
        if actionForKey("walk") != nil {
            removeActionForKey("walk")
        }
        
        //println("walking")
        if (abs(playerSpeedX) < abs(maxSpeed / 2) && walkingSlow == false  ) {
            
            walkingSlow = true
            self.runAction(slowWalkAction!, withKey: "walk")
            //println("should be walking slow")
            
        } else if (abs(playerSpeedX) > abs(maxSpeed / 2)  && walkingSlow == true ) {
            
            walkingSlow = false
            self.runAction(walkAction!, withKey: "walk")
            //println("should be walking")
            isRunning = true
            
        } else {
            walkingSlow = false
            self.runAction(runAction!, withKey: "walk")
            //println("should be running")
            isRunning = true
        }
    }
    
    func stopWalk() {
        
        if actionForKey("idle") != nil {
            removeActionForKey("idle")
        }
        
        self.runAction(idleAction!, withKey: "idle")
        removeActionForKey("walk")
        removeActionForKey("jump")
        removeActionForKey("fall")
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
    
    func setRising(rising: Bool) {
        if rising {
            isRising = true
        } else {
            isRising = false
        }
    }
    
    func setFalling(falling: Bool) {
        if falling {
            isFalling = true
            fall()
            //println("falling")
        } else {
            isFalling = false
            fall()
            //println("not falling")
        }
    }
    
    func fall() {
        if isFalling {
            if actionForKey("fall") != nil {
                removeActionForKey("fall")
            }
            self.runAction(fallAction!, withKey: "fall")
            println("falling")
        } else if !isFalling {
            removeActionForKey("fall")
        }
    }
    
    
    func jump() {
        if !isFalling {
            if (isJumping == false) {
                
                if actionForKey("jump") != nil {
                    removeActionForKey("jump")
                }
                
                //add arc4random to select jump or flip here
                self.runAction(jumpAction!, withKey: "jump")
                self.runAction(jumpSound)
                
                
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