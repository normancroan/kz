//
//  GameScene.swift
//  KZ
//
//  Created by Norman Croan on 5/30/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var tileMap = JSTileMap(named: "level-1.tmx")
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.anchorPoint = CGPoint(x: 0, y: 0)
        tileMap.position = CGPoint(x: 0, y: 0)
        addChild(tileMap)
        addFloor()
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func addFloor() {
        for var a = 0; a < Int(tileMap.mapSize.width); a++ { //Go through every point across the tile map
            for var b = 0; b < Int(tileMap.mapSize.height); b++ { //Go through every point up the tile map
                let layerInfo:TMXLayerInfo = tileMap.layers.firstObject as! TMXLayerInfo //Get the first layer (you may want to pick another layer if you don't want to use the first one on the tile map)
                let point = CGPoint(x: a, y: b) //Create a point with a and b
                let gid = layerInfo.layer.tileGidAt(layerInfo.layer.pointForCoord(point)) //The gID is the ID of the tile. They start at 1 up the the amount of tiles in your tile set.
                
                if gid == 383 || gid == 384 || gid == 387{ //My gIDs for the floor were 2, 9 and 8 so I checked for those values
                    let node = layerInfo.layer.tileAtCoord(point) //I fetched a node at that point created by JSTileMap
                    node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size) //I added a physics body
                    node.physicsBody?.dynamic = false
                    
                    //You now have a physics body on your floor tiles! :)
                }
            }
        }
    }

}
