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
    var tileMap = JSTileMap(named: "level-2.tmx")
    var tileMapFrame: CGRect!
    let player = Player(imageNamed: "knight")
    let buttonEast = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonWest = SKSpriteNode(imageNamed: "Directional_Button2")
    
    var playerSpeedX:CGFloat = 0.0
    var playerSpeedY:CGFloat = 0.0
    
    

    
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
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.blackColor()
        createWorld()
        worldNode.addChild(player)
        player.position = CGPointMake(55,235)
        player.setScale(0.5)
        
        centerViewOn(player.position)
        
        addChild(buttonWest)
        buttonWest.position = CGPoint(x: -290, y: -155)
        
        addChild(buttonEast)
        buttonEast.position = CGPoint(x: -200, y: -155)
        buttonEast.xScale = -1

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        centerViewOn(player.position)
    }
    
    
    
    func addFloor() {
        for var a = 0; a < Int(tileMap.mapSize.width); a++ { //Go through every point across the tile map
            for var b = 0; b < Int(tileMap.mapSize.height); b++ { //Go through every point up the tile map
                let layerInfo:TMXLayerInfo = tileMap.layers.lastObject as! TMXLayerInfo //Get the first layer (you may want to pick another layer if you don't want to use the first one on the tile map)
                let point = CGPoint(x: a, y: b) //Create a point with a and b
                let gid = layerInfo.layer.tileGidAt(layerInfo.layer.pointForCoord(point)) //The gID is the ID of the tile. They start at 1 up the the amount of tiles in your tile set.
                
                if gid == 383 || gid == 384 || gid == 385{ //My gIDs for the floor were 2, 9 and 8 so I checked for those values
                    let node = layerInfo.layer.tileAtCoord(point) //I fetched a node at that point created by JSTileMap
                    node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size) //I added a physics body
                    node.physicsBody?.dynamic = false
                    node.alpha = 0
                    println("added physics")
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
        let touch = touches.first as! UITouch
        //centerViewOn(touch.locationInNode(worldNode))
        
        player.physicsBody?.applyImpulse(CGVectorMake(0.0, 200.0))
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }

}
