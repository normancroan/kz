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
    
    var jumpLockOverride = false
    
    //MARK: Init
    required init(coder aDecoder: NSCoder) {
        fatalError("NScoding not supported")
    }
    
    init (imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color:nil, size: imageTexture.size() )
        setupPhysics(imageNamed, size: "full")
        
        setupAction("idle", characterName: "cat")
        //setupAction("walk", characterName: "cat")
        setupAction("run", characterName: "cat")
        setupAction("jump", characterName: "cat")
        setupAction("fall", characterName: "cat")
        setupAction("flip", characterName: "cat")
        //setupAction("jump attack", characterName: "cat")
        
        self.runAction(idleAction)
    }
    
    func setupPhysics(imageNamed: String, size: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        //just rectangle body
        var fullBodyRectangle = CGRectMake(position.x, position.y, imageTexture.size().width / 1.7, imageTexture.size().height / 1.5)
        
        var fullBodyRectangle2 = CGRectMake(position.x, position.y, imageTexture.size().width / 1.7, imageTexture.size().height / 2)
        
        var body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: fullBodyRectangle.size, center: CGPointMake(0, -20))
        
        var bodyJumping:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: fullBodyRectangle2.size, center: CGPointMake(0, -13))
        
        
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
        
        //dynamic required for gravity to work
        bodyJumping.dynamic = true
        //body.restitution = 0
        bodyJumping.affectedByGravity = true
        bodyJumping.allowsRotation = false
        //body.categoryBitMask = PhysicsCategory.Player
        bodyJumping.categoryBitMask = SKACategoryPlayer
        //body.collisionBitMask = PhysicsCategory.Floor | PhysicsCategory.Boundary
        bodyJumping.collisionBitMask = SKACategoryFloor | SKACategoryWall
        //body.contactTestBitMask = PhysicsCategory.All
        bodyJumping.contactTestBitMask = SKACategoryFloor
        bodyJumping.usesPreciseCollisionDetection = true
        
        if size == "full" {
            self.physicsBody = body
        } else if size == "jump" {
            self.physicsBody = bodyJumping
        }
    }
    
    func resizePhysics(size: CGSize) {
        if !isJumping{
        println("resized")
        
        var fullBodyRectangle = CGRectMake(position.x, position.y, size.width / 1.7, size.height / 1.25)
        
        var fullBodyRectangle2 = CGRectMake(position.x, position.y, size.width / 1.7, size.height / 2)
        
        var body:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: fullBodyRectangle.size, center: CGPointMake(0, -8))
        
        var bodyJumping:SKPhysicsBody = SKPhysicsBody(rectangleOfSize: fullBodyRectangle2.size, center: CGPointMake(0, -13))
        
        
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
        
        //dynamic required for gravity to work
        bodyJumping.dynamic = true
        //body.restitution = 0
        bodyJumping.affectedByGravity = true
        bodyJumping.allowsRotation = false
        //body.categoryBitMask = PhysicsCategory.Player
        bodyJumping.categoryBitMask = SKACategoryPlayer
        //body.collisionBitMask = PhysicsCategory.Floor | PhysicsCategory.Boundary
        bodyJumping.collisionBitMask = SKACategoryFloor | SKACategoryWall
        //body.contactTestBitMask = PhysicsCategory.All
        bodyJumping.contactTestBitMask = SKACategoryFloor
        bodyJumping.usesPreciseCollisionDetection = true
        
        self.physicsBody = body
        }
    }
    
    //MARK: Loop
    func update(dt: CGFloat) {
        //println(jumpAmount)
        //player vaulting
        if isJumping {
            if maxSpeed != 4 {
                maxSpeed = 4
                if playerSpeedX > 0 && playerSpeedX != maxSpeed {
                    playerSpeedX = maxSpeed
                } else if playerSpeedX < 0 && playerSpeedX != -maxSpeed {
                    playerSpeedX = -maxSpeed
                }
            }
        } else if !isJumping {
            if maxSpeed != 9 {
                maxSpeed = 9
                if playerSpeedX > 0 && playerSpeedX != maxSpeed {
                    playerSpeedX = maxSpeed
                } else if playerSpeedX < 0 && playerSpeedX != -maxSpeed {
                    playerSpeedX = -maxSpeed
                }
            }
        }
        //println(isJumping)
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
            frameSpeed = 80
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
            jumpSound = SKAction.playSoundFileNamed("jump_04.wav", waitForCompletion: false)
        } else if actionName == "jump attack" {
            jumpAttackAction = SKAction.repeatActionForever(atlasAnimation)
        } else if actionName == "walk" {
            walkAction = SKAction.repeatActionForever(atlasAnimation)
        } else if actionName == "fall" {
            fallAction = SKAction.repeatActionForever(atlasAnimation)
        } else if actionName == "flip" {
            let performSelector:SKAction = SKAction.runBlock(self.walkOrStop)
            let killAnimation:SKAction = SKAction.runBlock( endAnimation )
            //let resumeFall:SKAction = SKAction.runBlock( fall )
            flipAction =  SKAction.sequence([atlasAnimation, killAnimation, performSelector])
        }
    }
    
    func endAnimation(){
        if actionForKey("flip") != nil {
            removeActionForKey("flip")
        }
        if actionForKey("jump") != nil {
            removeActionForKey("jump")
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
            
            self.xScale = 0.6//1//0.4
        } else {
            
            self.xScale = -0.6//-1//-0.4
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
            //this is clipping the animation
            self.runAction(runAction!, withKey: "walk")
            //println("should be running")
            isRunning = true
        }
    }
    
    func stopWalk() {
        
        if actionForKey("idle") != nil {
            removeActionForKey("idle")
        }
        
        if actionForKey("flip") == nil {
            self.runAction(idleAction!, withKey: "idle")
        }
        
        removeActionForKey("walk")
        removeActionForKey("jump")
        removeActionForKey("fall")
        //println("idling")
        isRunning = false
        isFalling = false
        jumpLockOverride = false
        
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
            if actionForKey("jump") == nil
                && actionForKey("flip") == nil
                    && actionForKey("fall") == nil{
                self.runAction(fallAction!, withKey: "fall")
            }
        } else if !isFalling {
            if actionForKey("fall") != nil {
            removeActionForKey("fall")
            }
        }
    }
    
    func jump() {
        if jumpLockOverride {
            //moving this down into main body
            //self.physicsBody?.velocity.dy = 0
        }
        if !isFalling {
            if !isJumping {
                
                if actionForKey("jump") != nil {
                    removeActionForKey("jump")
                }
                //kill taper effect
                if actionForKey("taper") != nil {
                    removeActionForKey("taper")
                    stopJump()
                }
                
                //add arc4random to select jump or flip here
                let randomNumber = Int(arc4random_uniform(10))
                if randomNumber == 5 {
                    self.runAction(flipAction!, withKey: "flip")
                } else {
                    self.runAction(jumpAction!, withKey: "jump")
                }
    
                self.runAction(jumpSound)
                
                
                isJumping = true
                jumpLockOverride = false
                
                
                self.physicsBody?.velocity.dy = 0
                jumpAmount = maxJump
                
                let callAgain:SKAction = SKAction.runBlock( taperJump )
                let wait:SKAction = SKAction.waitForDuration(2/60)
                let seq:SKAction = SKAction.sequence([wait, callAgain])
                let repeat:SKAction = SKAction.repeatAction(seq, count: 5)
                let stop:SKAction = SKAction.runBlock( stopJump)
                let seq2:SKAction = SKAction.sequence([repeat, stop])
                
                self.runAction(seq2, withKey: "taper")
            }
        }
    }
    
    func taperJump() {
        
        jumpAmount = jumpAmount * 0.65//0.7
        //println(jumpAmount)
        if isJumping {
            isJumping = false
            //println("not jumping")
        }
    }
    
    func stopJump() {
        
        doubleJumpAlreadyUsed = false
        if !isJumping {
            isJumping = false
        }
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