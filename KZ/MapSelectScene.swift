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
    
    
    let activeMapIcon = SKSpriteNode(imageNamed: "kz_caves_background")
    let activeMapIconLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let buttonEast = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonWest = SKSpriteNode(imageNamed: "Directional_Button2")
    
    let instructionsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    
    var mapList = [String]()
    var mapNumber = 0
    
    func addMaps(){
        mapList.append("kz_caves")
        mapList.append("kz_egypt_3")
        mapList.append("kz_castle")
    }
    
    var activeMap: String = "kz_caves"
    
    func switchActiveMap(direction: String) {
            if direction == "up" {
                if mapNumber < (mapList.count - 1) {
                    mapNumber++
                    println("mapNumber is \(mapNumber)")
                    activeMap = mapList[mapNumber]
                }
            } else if direction == "down" {
                if mapNumber >= 1 {
                    mapNumber--
                    println("mapNumber is \(mapNumber)")
                    activeMap = mapList[mapNumber]
                }
            }
        }
    
    func updateLabels() {
        activeMapIconLabel.text = activeMap
        let backgroundString = "\(activeMap)_background"
        activeMapIcon.texture = SKTexture(imageNamed: backgroundString)
    }
    
    
    //let mapEffect = SKEmitterNode(fileNamed: "BehindTheMap.sks")
    
    func displayLabels() {
        let widthHalf:CGFloat = self.view!.bounds.width / 2
        let heightHalf:CGFloat = self.view!.bounds.height / 2
        
        instructionsLabel.fontSize = 20
        instructionsLabel.text = "Let's do this!"
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
        
        
        addChild(activeMapIcon)
        activeMapIcon.setScale(0.3)
        activeMapIcon.anchorPoint = CGPointMake(0.5, 0.5)
        activeMapIcon.position = CGPoint(x: widthHalf,y: heightHalf)
        
        
        activeMapIconLabel.fontSize = 15
        activeMapIconLabel.text = activeMap//"kz_caves"//"kz_egypt_3"
        activeMapIconLabel.name = "caves"
        activeMapIconLabel.zPosition = 200
        activeMapIconLabel.verticalAlignmentMode = .Center
        activeMapIconLabel.position = CGPoint(x: widthHalf,y: heightHalf - activeMapIcon.frame.height * 0.8)
        addChild(activeMapIconLabel)
    }
    
    func mapEffects(){
        let mapEmitter = SKEmitterNode(fileNamed: "BehindTheMap.sks")
        mapEmitter.position = activeMapIcon.position
        mapEmitter.zPosition = activeMapIcon.zPosition - 1
        addChild(mapEmitter)
    }
    
    override func didMoveToView(view: SKView) {
        displayLabels()
        addMaps()
        mapEffects()
        backgroundColor = SKColor.blackColor()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            //touched egypt
            if (CGRectContainsPoint(activeMapIcon.frame, location)) {
                instructionsLabel.text = "Loading..."
                let myScene = GameScene(size: self.size, currentMap: activeMap)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.fadeWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)

            //touched wild
            } else if (CGRectContainsPoint(buttonWest.frame, location)) {
                switchActiveMap("down")
                updateLabels()
            } else if (CGRectContainsPoint(buttonEast.frame, location)){
                switchActiveMap("up")
                updateLabels()
            }
        }
    }
}
