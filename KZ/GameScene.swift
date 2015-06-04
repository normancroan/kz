//
//  GameScene.swift
//  KZ
//
//  Created by Norman Croan on 5/30/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var worldNode: SKNode!
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    var tileMap = JSTileMap(named: "kz_egypt.tmx")
    var tileMapFrame: CGRect!
    var moveButtonIsPressed = false
    var jumpButtonIsPressed = false
    var intendsToKeepRunning = false
    let player = Player(imageNamed: "Walk13")
    let buttonEast = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonWest = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonNorth = SKSpriteNode(imageNamed: "Directional_Button")
    
    
    
    
    func createWorld() {
        worldNode = SKNode()
        worldNode.addChild(tileMap)
        addChild(worldNode)
        addFloor()
        tileMapFrame = tileMap.calculateAccumulatedFrame()
        
        anchorPoint = CGPointMake(0.5,0.5)
        worldNode.position = CGPointMake(-tileMapFrame.width / 2, -tileMapFrame.height / 2)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "background_egypt")
        self.addChild(background)
        background.zPosition = -100
        background.xScale = 1.25
        background.yScale = background.xScale
        background.position = CGPointMake(0, 50)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //backgroundColor = SKColor.blackColor()
        createBackground()
        createWorld()
        worldNode.addChild(player)
        player.position = CGPointMake(55,235)
        player.zPosition = -41
        //player.position = CGPointMake(955,2235)
        player.setScale(0.7)
        
        centerViewOn(player.position)
        
        let widthHalf:CGFloat = self.view!.bounds.width / 2
        let heightHalf:CGFloat = self.view!.bounds.height / 2

        addChild(buttonNorth)
        buttonNorth.position = CGPoint(x: widthHalf - (buttonNorth.size.width), y: -heightHalf + (buttonWest.size.height * 0.6))

        addChild(buttonWest)
        buttonWest.position = CGPoint(x: -widthHalf + buttonWest.size.width, y: -heightHalf + (buttonWest.size.height * 0.6))
        
        addChild(buttonEast)
        buttonEast.position = CGPoint(x: buttonWest.position.x + (buttonWest.size.width * 2), y: buttonWest.position.y)
        buttonEast.xScale = -1
        

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //delta
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        //println("\(dt) is the dt")
        //end delta
        centerViewOn(player.position)
        player.update(CGFloat(dt))
        if player.physicsBody?.velocity.dy >= -75.0 || (player.physicsBody?.velocity.dy <= 20.0) && (player.physicsBody?.velocity.dy >= -10.0){//!= 0.0 {
            player.setFalling(false)
            if player.physicsBody?.velocity.dy != 0.0 {
            }
        } else {
            player.setFalling(true)
        }
    }
    
    
    func addFloor() {
        for var a = 0; a < Int(tileMap.mapSize.width); a++ { //Go through every point across the tile map
            for var b = 0; b < Int(tileMap.mapSize.height); b++ { //Go through every point up the tile map
                let layerInfo:TMXLayerInfo = tileMap.layers.lastObject as! TMXLayerInfo //Get the first layer (you may want to pick another layer if you don't want to use the first one on the tile map)
                let point = CGPoint(x: a, y: b) //Create a point with a and b
                let gid = layerInfo.layer.tileGidAt(layerInfo.layer.pointForCoord(point)) //The gID is the ID of the tile. They start at 1 up the the amount of tiles in your tile set.
                
                if gid == 383 || gid == 384 || gid == 385 || gid == 491{ //My gIDs for the floor were 2, 9 and 8 so I checked for those values
                    let node = layerInfo.layer.tileAtCoord(point) //I fetched a node at that point created by JSTileMap
                    node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size) //I added a physics body
                    node.physicsBody?.dynamic = false
                    node.physicsBody?.restitution = 0
                    node.physicsBody?.friction
                    node.alpha = 0
                    node.physicsBody?.categoryBitMask = PhysicsCategory.Floor
                    node.physicsBody?.contactTestBitMask = PhysicsCategory.Player
                    //println("added physics")
                    //You now have a physics body on your floor tiles! :)
                }
            }
        }
    }
    
    //MARK: - Camera
    func centerViewOn(centerOn: CGPoint) {
        let x = centerOn.x.clamped(size.width / 2, tileMapFrame.width - size.width / 2)
        let y = centerOn.y.clamped(size.height / 2, tileMapFrame.height - size.height / 2)
        worldNode.position = CGPoint(x: -x, y: -y)
    }
    
    //MARK: - Touch Handling
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        
        //building larger frames for east and west buttons
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let eastFrame:CGRect = CGRectMake(buttonEast.position.x, buttonEast.position.y, buttonEast.frame.width * 2, buttonEast.frame.height * 2)
            let eastFrame2:CGRect = CGRectMake(buttonEast.position.x - (eastFrame.size.width / 2), buttonEast.position.y - (eastFrame.size.height / 2), buttonEast.frame.width * 2, buttonEast.frame.height * 2)
            
            let westFrame:CGRect = CGRectMake(buttonWest.position.x, buttonWest.position.y, buttonWest.frame.width * 2, buttonWest.frame.height * 2)
            let westFrame2:CGRect = CGRectMake(buttonWest.position.x - (westFrame.size.width / 2), buttonWest.position.y - (westFrame.size.height / 2), buttonWest.frame.width * 2, buttonWest.frame.height * 2)
            
//            let northFrame:CGRect = CGRectMake(buttonNorth.position.x, buttonNorth.position.y, buttonNorth.frame.width * 3, buttonNorth.frame.height * 3)
//            let northFrame2:CGRect = CGRectMake(buttonNorth.position.x - (northFrame.size.width / 3), buttonNorth.position.y - (northFrame.size.height / 3), buttonNorth.frame.width * 3, buttonNorth.frame.height * 3)
            
            
        //end building larger frames
            
            
            //touched right
            if (CGRectContainsPoint(eastFrame2, location)) {
                
                //currentState = MoveStates.E
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2_Lit")
                moveButtonIsPressed = true
                player.playerSpeedX = player.maxSpeed
                player.adjustXSpeedAndScale()
                player.startWalk()
                //determineRunIntentions()
                
            //touched left
            }  else if (CGRectContainsPoint(westFrame2, location)) {
                
                //currentState = MoveStates.W
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2_Lit")
                moveButtonIsPressed = true
                player.playerSpeedX = -player.maxSpeed
                player.adjustXSpeedAndScale()
                player.startWalk()
                //determineRunIntentions()
                
            //jumped
            } else {
                buttonNorth.texture = SKTexture(imageNamed: "Directional_Button_Lit")
                jumpButtonIsPressed = true
                player.jump()
            }
        }
    }
    
    func endWalkAfterJump() {
        player.stopWalk()
        player.playerSpeedX = 0
        moveButtonIsPressed = false
        buttonEast.texture = SKTexture(imageNamed: "Directional_Button2")
        buttonWest.texture = SKTexture(imageNamed: "Directional_Button2")
    }
    
    func updateRunIntentions(intention: String) {
        if intention == "run" {
           // println("will keep running")
            intendsToKeepRunning = true
        } else {
            intendsToKeepRunning = false
        }
    }
    
    func determineRunIntentions() {
        if moveButtonIsPressed {
            let wait = SKAction.waitForDuration(0.5)
            let update = SKAction.runBlock({ self.updateRunIntentions("run")})
            let seq = SKAction.sequence([wait, update])
            runAction(seq, withKey: "checking")
        } else {
            updateRunIntentions("stop")
        }
    }
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        for touch in (touches as! Set<UITouch>){
            let location = touch.locationInNode(self)

            let eastFrame:CGRect = CGRectMake(buttonEast.position.x, buttonEast.position.y, buttonEast.frame.width * 2, buttonEast.frame.height * 2)
            let eastFrame2:CGRect = CGRectMake(buttonEast.position.x - (eastFrame.size.width / 2), buttonEast.position.y - (eastFrame.size.height / 2), buttonEast.frame.width * 2, buttonEast.frame.height * 2)
            
            let westFrame:CGRect = CGRectMake(buttonWest.position.x, buttonWest.position.y, buttonWest.frame.width * 2, buttonWest.frame.height * 2)
            let westFrame2:CGRect = CGRectMake(buttonWest.position.x - (westFrame.size.width / 2), buttonWest.position.y - (westFrame.size.height / 2), buttonWest.frame.width * 2, buttonWest.frame.height * 2)
            

            if (CGRectContainsPoint(eastFrame2, location)){
                //println("touch ended on right button")
                player.stopWalk()
                player.playerSpeedX = 0
                moveButtonIsPressed = false
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2")
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2")
                //removeActionForKey("checking")
                //updateRunIntentions("stop")

            } else if (CGRectContainsPoint(westFrame2, location)) {
                //println("touch ended on left button")
                player.stopWalk()
                player.playerSpeedX = 0
                moveButtonIsPressed = false
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2")
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2")
                //removeActionForKey("checking")
                //updateRunIntentions("stop")

            } else {
                //println("touch ended in jump territory")
            }
        }


        if moveButtonIsPressed && !jumpButtonIsPressed {
            
            //println("just the move was pressed")
            player.stopWalk()
            player.playerSpeedX = 0
            moveButtonIsPressed = false
            buttonEast.texture = SKTexture(imageNamed: "Directional_Button2")
            buttonWest.texture = SKTexture(imageNamed: "Directional_Button2")
            //removeActionForKey("checking")
            //updateRunIntentions("stop")
            
        } else if jumpButtonIsPressed && !moveButtonIsPressed {
            //println("just the jump was pressed")
            jumpButtonIsPressed = false
            buttonNorth.texture = SKTexture(imageNamed: "Directional_Button")
        
        } else if moveButtonIsPressed && jumpButtonIsPressed {
            //println("both were pressed")
            jumpButtonIsPressed = false
            buttonNorth.texture = SKTexture(imageNamed: "Directional_Button")
            //resolving the sticky button issue with simultaneous presses
//            if !intendsToKeepRunning {
//            removeActionForKey("checking")
//            let wait = SKAction.waitForDuration(0.35)
//            let stop = SKAction.runBlock({ self.endWalkAfterJump() })
//            let stop2 = SKAction.runBlock({ self.updateRunIntentions("stop") })
//            let seq = SKAction.sequence([wait, stop, stop2])
//            runAction(seq)
//            }
            //end anti stick code, update with intendsToRun soon
        }
    }

}
