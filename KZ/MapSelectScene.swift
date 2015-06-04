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
        egyptIcon.setScale(0.3)
        egyptIcon.position = CGPoint(x: widthHalf + (egyptIcon.size.width / 2) + 10, y: heightHalf)
        
        addChild(wildIcon)
        wildIcon.setScale(0.3)
        wildIcon.position = CGPoint(x: widthHalf - (wildIcon.size.width / 2) - 10, y: heightHalf)
        
        egyptIconLabel.fontSize = 30
        egyptIconLabel.text = "kz_egypt"
        egyptIconLabel.name = "egypt"
        egyptIconLabel.zPosition = 200
        egyptIconLabel.verticalAlignmentMode = .Center
        egyptIconLabel.position = CGPoint(x: egyptIcon.position.x, y: egyptIcon.position.y - (egyptIcon.size.height / 1.5))
        addChild(egyptIconLabel)
        
        wildIconLabel.fontSize = 30
        wildIconLabel.text = "kz_wild"
        wildIconLabel.name = "wild"
        wildIconLabel.zPosition = 200
        wildIconLabel.verticalAlignmentMode = .Center
        wildIconLabel.position = CGPoint(x: wildIcon.position.x, y: wildIcon.position.y - (wildIcon.size.height / 1.5))
        addChild(wildIconLabel)
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

            }
        }
    }
    
}
