//
//  Item.swift
//  KZ
//
//  Created by Norman Croan on 6/19/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import Foundation
import SpriteKit

class Item: SKSpriteNode {


required init(coder aDecoder: NSCoder) {
    fatalError("NScoding not supported")
    }

    init (imageNamed: String, objectNamed: String) {
    let imageTexture = SKTexture(imageNamed: imageNamed)
    super.init(texture: imageTexture, color:nil, size: imageTexture.size() )
    
    
    var body:SKPhysicsBody = SKPhysicsBody(circleOfRadius: imageTexture.size().width / 2)
        body.affectedByGravity = false
        body.categoryBitMask = PhysicsCategory.Item
        //body.collisionBitMask = SKACategoryPlayer
        body.contactTestBitMask = SKACategoryPlayer
        self.physicsBody = body
    
        var atlasSt = "GemGreenIdle"
        var formatSt = "gem_green_%i"
        var atlasStrt = 1
        var atlasStp = 7
        
        if objectNamed == "greenGem" {
            atlasSt = "GemGreenIdle"
            formatSt = "gem_green_%i"
            atlasStrt = 1
            atlasStp = 7
        } else if objectNamed == "redGem" {
            atlasSt = "GemRedIdle"
            formatSt = "gem_red_%i"
            atlasStrt = 1
            atlasStp = 7
        }
        
//        setUpIdleAction("GemGreenIdle", formatString: "gem_green_%i", atlasStart: atlasStart, atlastStop: atlasStop)
        setUpIdleAction(atlasSt, formatString: formatSt, atlasStart: atlasStrt, atlasStop: atlasStp)
        self.runAction(idleAction)
    
    }
    
    var idleAction:SKAction?
    
    func setUpIdleAction(atlasString: String, formatString: String, atlasStart: Int, atlasStop: Int) {
        
        let atlas = SKTextureAtlas (named: atlasString)
        
        var array = [String]()
        
        for var i=atlasStart; i < atlasStop; i++ {
            
            let nameString = String(format: formatString, i)
            array.append(nameString)
            
        }
        
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++ ) {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 0.05, resize: true , restore:false )
        idleAction =  SKAction.repeatActionForever(atlasAnimation)

    }
    

}