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
    
    let instructionsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    
    func displayLabels() {
        let widthHalf:CGFloat = self.view!.bounds.width / 2
        let heightHalf:CGFloat = self.view!.bounds.height / 2
        
        instructionsLabel.fontSize = 30
        instructionsLabel.text = "Select a world to begin"
        instructionsLabel.name = "instructions"
        instructionsLabel.zPosition = 200
        instructionsLabel.verticalAlignmentMode = .Center
        instructionsLabel.position = CGPoint(x: widthHalf, y: heightHalf + (heightHalf * 0.8))
        addChild(instructionsLabel)
        
        
        addChild(egyptIcon)
        egyptIcon.setScale(0.2)
        egyptIcon.anchorPoint = CGPointMake(0.5, 0.5)
        egyptIcon.position = CGPoint(x: wildIcon.position.x + egyptIcon.size.width * 1.6, y: heightHalf)
        
        addChild(wildIcon)
        wildIcon.setScale(0.2)
        wildIcon.anchorPoint = CGPointMake(0.5, 0.5)
        wildIcon.position = CGPoint(x: widthHalf / 3, y: heightHalf)
        
        addChild(wonderlandIcon)
        wonderlandIcon.setScale(0.1)
        wonderlandIcon.position = CGPoint(x: egyptIcon.position.x + egyptIcon.size.width * 1.05, y: heightHalf)
        
        egyptIconLabel.fontSize = 25
        egyptIconLabel.text = "kz_egypt"
        egyptIconLabel.name = "egypt"
        egyptIconLabel.zPosition = 200
        egyptIconLabel.verticalAlignmentMode = .Center
        egyptIconLabel.position = CGPoint(x: egyptIcon.position.x, y: egyptIcon.position.y - (egyptIcon.size.height / 1.5))
        addChild(egyptIconLabel)
        
        wildIconLabel.fontSize = 25
        wildIconLabel.text = "kz_wild"
        wildIconLabel.name = "wild"
        wildIconLabel.zPosition = 200
        wildIconLabel.verticalAlignmentMode = .Center
        wildIconLabel.position = CGPoint(x: wildIcon.position.x, y: wildIcon.position.y - (wildIcon.size.height / 1.5))
        addChild(wildIconLabel)
        
        
        wonderlandIconLabel.fontSize = 25
        wonderlandIconLabel.text = "kz_wonderland"
        wonderlandIconLabel.name = "wonderland"
        wonderlandIconLabel.zPosition = 200
        wonderlandIconLabel.verticalAlignmentMode = .Center
        wonderlandIconLabel.position = CGPoint(x: wonderlandIcon.position.x, y: wonderlandIcon.position.y - (wonderlandIcon.size.height / 1.5))
        addChild(wonderlandIconLabel)
    }
    
    override func didMoveToView(view: SKView) {
        displayLabels()
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
            }
        }
    }
    
}
