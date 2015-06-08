//
//  MapSelectScene.swift
//  KZ
//
//  Created by Norman Croan on 6/4/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import Foundation
import SpriteKit

class MapSelectScene: SKScene {
    
    
    let egyptIcon = SKSpriteNode(imageNamed: "kz_egypt_background")
    let egyptIconLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let wildIcon = SKSpriteNode(imageNamed: "kz_wild_background")
    let wildIconLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let wonderlandIcon = SKSpriteNode(imageNamed: "kz_wonderland_background")
    let wonderlandIconLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let dreamIcon = SKSpriteNode(imageNamed: "kz_dream_background")
    let dreamIconLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    
    let panel1 = SKSpriteNode(imageNamed: "panel_blue")
    let panel2 = SKSpriteNode(imageNamed: "panel_blue")
    let panel3 = SKSpriteNode(imageNamed: "panel_blue")
    let panel4 = SKSpriteNode(imageNamed: "panel_blue")
    
    var dreamMapLocked = true
    
    
    let instructionsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    
    func displayLabels() {
        let widthHalf:CGFloat = self.view!.bounds.width / 2
        let heightHalf:CGFloat = self.view!.bounds.height / 2
        
        instructionsLabel.fontSize = 20
        instructionsLabel.text = "Time to choose"
        instructionsLabel.name = "instructions"
        instructionsLabel.zPosition = 200
        instructionsLabel.verticalAlignmentMode = .Center
        instructionsLabel.position = CGPoint(x: widthHalf, y: heightHalf)
        addChild(instructionsLabel)
        
        
        addChild(egyptIcon)
        egyptIcon.setScale(0.2)
        egyptIcon.anchorPoint = CGPointMake(0.5, 0.5)
        egyptIcon.position = CGPoint(x: widthHalf * 1.5 ,y: heightHalf * 1.5)
        
        addChild(wildIcon)
        wildIcon.setScale(0.2)
        wildIcon.anchorPoint = CGPointMake(0.5, 0.5)
        wildIcon.position = CGPoint(x: widthHalf / 2,y: heightHalf * 1.5)
        
        addChild(wonderlandIcon)
        wonderlandIcon.setScale(0.2)
        wonderlandIcon.position = CGPoint(x: widthHalf / 2 ,y: heightHalf / 2)
        
        addChild(dreamIcon)
        dreamIcon.setScale(0.2)
        dreamIcon.anchorPoint = CGPointMake(0.5, 0.5)
        dreamIcon.position = CGPoint(x: widthHalf * 1.5 ,y: heightHalf / 2)
        dreamIcon.color = SKColor.blackColor()
        dreamIcon.colorBlendFactor = 0.7
        
        addChild(panel1)
        panel1.zPosition = (dreamIcon.zPosition - 1)
        panel1.position = wildIcon.position
        panel1.anchorPoint = CGPointMake(0.5, 0.5)
        panel1.size.width = dreamIcon.size.width * 1.1
        panel1.size.height = dreamIcon.size.height * 1.1
        panel1.alpha = 0.4
        
        addChild(panel2)
        panel2.zPosition = (dreamIcon.zPosition - 1)
        panel2.position = egyptIcon.position
        panel2.anchorPoint = CGPointMake(0.5, 0.5)
        panel2.size.width = dreamIcon.size.width * 1.1
        panel2.size.height = dreamIcon.size.height * 1.1
        panel2.alpha = 0.4

        
        addChild(panel3)
        panel3.zPosition = (dreamIcon.zPosition - 1)
        panel3.position = wonderlandIcon.position
        panel3.anchorPoint = CGPointMake(0.5, 0.5)
        panel3.size.width = dreamIcon.size.width * 1.1
        panel3.size.height = dreamIcon.size.height * 1.1
        panel3.alpha = 0.4

        
        addChild(panel4)
        panel4.zPosition = (dreamIcon.zPosition - 1)
        panel4.position = dreamIcon.position
        panel4.anchorPoint = CGPointMake(0.5, 0.5)
        panel4.size.width = dreamIcon.size.width * 1.1
        panel4.size.height = dreamIcon.size.height * 1.1
        panel4.alpha = 0.4

        
        
        egyptIconLabel.fontSize = 15
        egyptIconLabel.text = "kz_egypt"
        egyptIconLabel.name = "egypt"
        egyptIconLabel.zPosition = 200
        egyptIconLabel.verticalAlignmentMode = .Center
        egyptIconLabel.position = egyptIcon.position
        addChild(egyptIconLabel)
        
        wildIconLabel.fontSize = 15
        wildIconLabel.text = "kz_wild"
        wildIconLabel.name = "wild"
        wildIconLabel.zPosition = 200
        wildIconLabel.verticalAlignmentMode = .Center
        wildIconLabel.position = wildIcon.position
        addChild(wildIconLabel)
        
        
        wonderlandIconLabel.fontSize = 15
        wonderlandIconLabel.text = "kz_wonderland"
        wonderlandIconLabel.name = "wonderland"
        wonderlandIconLabel.zPosition = 200
        wonderlandIconLabel.verticalAlignmentMode = .Center
        wonderlandIconLabel.position = wonderlandIcon.position
        addChild(wonderlandIconLabel)
        
        dreamIconLabel.fontSize = 15
        dreamIconLabel.text = "kz_dream"
        dreamIconLabel.name = "dream"
        dreamIconLabel.zPosition = 200
        dreamIconLabel.verticalAlignmentMode = .Center
//        dreamIconLabel.position = CGPoint(x: dreamIcon.position.x, y: dreamIcon.position.y - (dreamIcon.size.height / 1.5))
        dreamIconLabel.position = dreamIcon.position
        //addChild(dreamIconLabel)
    }
    
    override func didMoveToView(view: SKView) {
        displayLabels()
        backgroundColor = SKColor.blackColor()
        
        
        
        let turnBlack = SKAction.colorizeWithColor(SKColor.blackColor(), colorBlendFactor: 0.7, duration: 3.0)
        let turnRed = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.9, duration: 3.0)
        let turnOrange = SKAction.colorizeWithColor(SKColor.orangeColor(), colorBlendFactor: 0.9, duration: 3.0)
        let turnPurple = SKAction.colorizeWithColor(SKColor.purpleColor(), colorBlendFactor: 0.9, duration: 3.0)
        let sequence = SKAction.sequence([turnOrange, turnBlack, turnRed, turnBlack, turnPurple, turnBlack])
        let repeat = SKAction.repeatActionForever(sequence)
        dreamIcon.runAction(repeat)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            //touched egypt
            if (CGRectContainsPoint(egyptIcon.frame, location)) {
                instructionsLabel.text = "Loading kz_egypt..."
                let myScene = GameScene(size: self.size, currentMap: "kz_egypt")
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.fadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)

            //touched wild
            }  else if (CGRectContainsPoint(wildIcon.frame, location)) {
                instructionsLabel.text = "Loading kz_wild..."
                let myScene = GameScene(size: self.size, currentMap: "kz_wild")
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.fadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)

            } else if (CGRectContainsPoint(wonderlandIcon.frame, location)) {
                instructionsLabel.text = "Loading kz_wonderland..."
                let myScene = GameScene(size: self.size, currentMap: "kz_wonderland")
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.fadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)
                
            } else if (CGRectContainsPoint(dreamIcon.frame, location)) {
                if !dreamMapLocked {
                instructionsLabel.text = "Loading kz_dream..."
                let myScene = GameScene(size: self.size, currentMap: "kz_dream")
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.fadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)
                }
            }
        }
    }
    
}
