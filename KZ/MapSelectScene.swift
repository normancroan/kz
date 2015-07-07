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
    
    
    let activeMapIcon = SKSpriteNode(imageNamed: "kz_egypt_3_background")
    let activeMapIconLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let buttonEast = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonWest = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonNorth = SKSpriteNode(imageNamed: "Directional_Button")
    
    let instructionsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let statsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let bestTimeLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    //let runCountLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")


    
    var selectSound:SKAction?
    var changeSound:SKAction?
    var mapList = [String]()
    var mapNumber = 0
    var mapBestTime = 0
    var mapRunCount = 0

    
    func addMaps(){
        mapList.append("kz_egypt_3")
        //mapList.append("kz_wonderland_2")
        mapList.append("kz_caves")
        mapList.append("kz_castle")
    }
    
    var activeMap: String = "kz_egypt_3"
    

    
    func switchActiveMap(direction: String) {
            if direction == "up" {
                if mapNumber == (mapList.count - 1){
                    mapNumber = -1
                }
                if mapNumber < (mapList.count - 1) {
                    mapNumber++
                    activeMap = mapList[mapNumber]
                }
            } else if direction == "down" {
                if mapNumber == 0 {
                    mapNumber = mapList.count
                }
                if mapNumber >= 1 {
                    mapNumber--
                    activeMap = mapList[mapNumber]
                }
            }
        }
    
    func loadMapStats() {
        if let mapTime = NSUserDefaults.standardUserDefaults().stringForKey("\(activeMap)_time") {
            let mapSeconds:Int = mapTime.toInt()!
            printSecondsToHoursMinutesSeconds(mapSeconds)
        } else {
            bestTimeLabel.text = "Not Completed"
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func printSecondsToHoursMinutesSeconds (seconds: Int) -> () {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds)
        println ("\(h) Hours, \(m) Minutes, \(s) Seconds")
        bestTimeLabel.text = "Best Time: \(h)h \(m)m \(s)s"
    }
    
    func updateLabels() {
        loadMapStats()
        activeMapIconLabel.text = activeMap
        let backgroundString = "\(activeMap)_background"
        activeMapIcon.texture = SKTexture(imageNamed: backgroundString)
    }
    
    
    //let mapEffect = SKEmitterNode(fileNamed: "BehindTheMap.sks")
    
    func displayLabels() {
        let widthHalf:CGFloat = self.view!.bounds.width / 2
        let heightHalf:CGFloat = self.view!.bounds.height / 2
        
        instructionsLabel.fontSize = 20
        instructionsLabel.text = "Jump to enter map"
        instructionsLabel.name = "instructions"
        instructionsLabel.zPosition = 200
        instructionsLabel.verticalAlignmentMode = .Center
        instructionsLabel.position = CGPoint(x: widthHalf, y: (heightHalf) - (heightHalf / 1.25))
        addChild(instructionsLabel)
        
        statsLabel.fontSize = 20
        statsLabel.text = "Stats for this map"
        statsLabel.name = "instructions"
        statsLabel.zPosition = 200
        statsLabel.verticalAlignmentMode = .Center
        statsLabel.horizontalAlignmentMode = .Right
        statsLabel.position = CGPoint(x: widthHalf - (widthHalf / 2.5), y: heightHalf)
        addChild(statsLabel)
        
        bestTimeLabel.fontSize = 15
        bestTimeLabel.text = "Not Completed"
        bestTimeLabel.name = "instructions"
        bestTimeLabel.zPosition = 200
        bestTimeLabel.verticalAlignmentMode = .Center
        bestTimeLabel.horizontalAlignmentMode = .Right
        bestTimeLabel.position = CGPoint(x: statsLabel.position.x, y: statsLabel.position.y - bestTimeLabel.frame.size.height)
        addChild(bestTimeLabel)

        
        addChild(buttonWest)
        buttonWest.position = CGPoint(x: (widthHalf - widthHalf) + buttonWest.size.width, y: (heightHalf - heightHalf) + (buttonWest.size.height * 0.8))
        buttonWest.zPosition = 400
        
        addChild(buttonEast)
        buttonEast.position = CGPoint(x: buttonWest.position.x + (buttonWest.size.width * 2), y: buttonWest.position.y)
        buttonEast.xScale = -1
        buttonEast.zPosition = 200
        
        addChild(buttonNorth)
        buttonNorth.position = CGPoint(x: (widthHalf + widthHalf) - (buttonNorth.size.width), y: buttonWest.position.y)
        buttonNorth.zPosition = 200

        
        
        addChild(activeMapIcon)
        activeMapIcon.setScale(0.2)
        activeMapIcon.anchorPoint = CGPointMake(0.5, 0.5)
        activeMapIcon.position = CGPoint(x: widthHalf,y: (heightHalf - 20))
        
        
        activeMapIconLabel.fontSize = 15
        activeMapIconLabel.text = activeMap
        activeMapIconLabel.name = "\(activeMap)"
        activeMapIconLabel.zPosition = 200
        activeMapIconLabel.verticalAlignmentMode = .Center
        activeMapIconLabel.position = CGPoint(x: widthHalf,y: heightHalf - activeMapIcon.frame.height * 0.8)
        addChild(activeMapIconLabel)
        
        changeSound = SKAction.playSoundFileNamed("Blip_Select.wav", waitForCompletion: false)
    }
    
    func mapEffects(){
        let mapEmitter = SKEmitterNode(fileNamed: "BehindTheMap.sks")
        mapEmitter.position = activeMapIcon.position
        mapEmitter.zPosition = activeMapIcon.zPosition - 1
        addChild(mapEmitter)
    }
    
    override func didMoveToView(view: SKView) {
        addMaps()
        activeMap = mapList[0]
        displayLabels()
        //mapEffects()
        let background = SKSpriteNode(imageNamed: "kz_map_select")
        background.size = self.frame.size
        background.position = CGPoint(x: (self.frame.size.width / 2), y: (self.frame.size.height / 2))
        addChild(background)
        background.zPosition = -1
        //backgroundColor = SKColor.blackColor()
        if backgroundMusicPlayer != nil {
            backgroundMusicPlayer.stop()
        }
        playBackgroundMusic("main_menu.wav")
        
        //println(String("\(activeMap)","Hello","My","Old","Friend"))
        updateLabels()
    }
    
    func prepareToLoadTheMap() {
        //explosion sound
        selectSound = SKAction.playSoundFileNamed("SFX_Explosion_02.wav", waitForCompletion: false)
        let playSound = SKAction.runBlock({
            self.runAction(self.selectSound)
        })
        //changing the instructions label
        let showLoadingLabel = SKAction.runBlock({
        self.instructionsLabel.text = "HANG ON! Loading: \(self.activeMap)"
        })
        //loading the map
        let loadMap = SKAction.runBlock({  self.loadTheMap()  })
        
        //wrapping it all up in a sequence
        let seq = SKAction.sequence([showLoadingLabel, playSound, loadMap])
        //running the sequence
        runAction(seq)
    }
    
    func loadTheMap() {
        println("loading the map")
        let myScene = GameScene(size: self.size, currentMap: activeMap)
        myScene.scaleMode = self.scaleMode
        let reveal = SKTransition.fadeWithDuration(0.5)
        self.view?.presentScene(myScene, transition: reveal)
        self.removeFromParent()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            if (CGRectContainsPoint(buttonWest.frame, location)) {
                switchActiveMap("down")
                updateLabels()
                runAction(changeSound)
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2_Lit")
            } else if (CGRectContainsPoint(buttonEast.frame, location)){
                switchActiveMap("up")
                updateLabels()
                runAction(changeSound)
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2_Lit")
            } else if (CGRectContainsPoint(buttonNorth.frame, location)){
                prepareToLoadTheMap()
                buttonNorth.texture = SKTexture(imageNamed: "Directional_Button_Lit")
            }

        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            //touched activeMap
            if (CGRectContainsPoint(buttonWest.frame, location)) {
                //unlight
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2")
            } else if (CGRectContainsPoint(buttonEast.frame, location)){
                //unlight
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2")
            } else if (CGRectContainsPoint(buttonNorth.frame, location)){
                buttonNorth.texture = SKTexture(imageNamed: "Directional_Button")
            } else {
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2")
                buttonNorth.texture = SKTexture(imageNamed: "Directional_Button")
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2")
            }
        }
    }
}
