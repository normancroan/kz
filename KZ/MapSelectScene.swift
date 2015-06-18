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
    
    
    let egyptIcon = SKSpriteNode(imageNamed: "kz_egypt_3_background")
    let egyptIconLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let buttonEast = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonWest = SKSpriteNode(imageNamed: "Directional_Button2")
    
    let instructionsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    
    //let mapEffect = SKEmitterNode(fileNamed: "BehindTheMap.sks")
    
    func displayLabels() {
        let widthHalf:CGFloat = self.view!.bounds.width / 2
        let heightHalf:CGFloat = self.view!.bounds.height / 2
        
        instructionsLabel.fontSize = 20
        instructionsLabel.text = "Map Select (currently inactive)"
        instructionsLabel.name = "instructions"
        instructionsLabel.zPosition = 200
        instructionsLabel.verticalAlignmentMode = .Center
        instructionsLabel.position = CGPoint(x: widthHalf, y: self.view!.bounds.height - instructionsLabel.frame.height)
        addChild(instructionsLabel)
        
        buttonWest.position = CGPoint(x: widthHalf * 0.25, y: heightHalf)
        addChild(buttonWest)
        
        buttonEast.position = CGPoint(x: widthHalf * 1.75, y: heightHalf)
        buttonEast.xScale *= -1
        addChild(buttonEast)
        
        
        addChild(egyptIcon)
        egyptIcon.setScale(0.3)
        egyptIcon.anchorPoint = CGPointMake(0.5, 0.5)
        egyptIcon.position = CGPoint(x: widthHalf,y: heightHalf)
        
        
        egyptIconLabel.fontSize = 15
        egyptIconLabel.text = "kz_egypt_3"
        egyptIconLabel.name = "egypt_3"
        egyptIconLabel.zPosition = 200
        egyptIconLabel.verticalAlignmentMode = .Center
        egyptIconLabel.position = CGPoint(x: widthHalf,y: heightHalf - egyptIcon.frame.height * 0.8)
        addChild(egyptIconLabel)
    }
    
    func mapEffects(){
        let mapEmitter = SKEmitterNode(fileNamed: "BehindTheMap.sks")
        mapEmitter.position = egyptIcon.position
        mapEmitter.zPosition = egyptIcon.zPosition - 1
        addChild(mapEmitter)
    }
    
    override func didMoveToView(view: SKView) {
        displayLabels()
        mapEffects()
        backgroundColor = SKColor.blackColor()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            //touched egypt
            if (CGRectContainsPoint(egyptIcon.frame, location)) {
                instructionsLabel.text = "Loading kz_egypt..."
                let myScene = GameScene(size: self.size, currentMap: "kz_egypt_3")
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.fadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)

            //touched wild
            }
        }
    }
}
