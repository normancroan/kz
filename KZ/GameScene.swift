//
//  GameScene.swift
//  KZ
//
//  Created by Norman Croan on 5/30/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    init(size: CGSize, currentMap: String) {
        self.currentMap = currentMap
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Properties
    var worldNode: SKNode!
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    //var tileMap = JSTileMap(named: "I ADDED THIS CODE")
//    var tileMap = SKATiledMap(mapName: "kz_egypt_3")
    var tileMap = SKATiledMap(mapName: "kz_caves")//"kz_caves"
    var tileMapFrame: CGRect!
    var moveButtonIsPressed = false
    var jumpButtonIsPressed = false

    
    //checkpoint variables
    var savePoint:CGPoint = CGPoint.zeroPoint
    var savePointsRemaining = 25
    
    //stopwatch variables
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    let stopWatchLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")

    
    
    
    //MARK: Constants
    //checkpoint constants
    let savePointLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    let savePointsRemainingLabel = SKLabelNode(fontNamed: "AvenirNextCondensed")
    //end checkpoint constants
    let currentMap: String
    let player = Player(imageNamed: "Walk13")
    let greenGem = Item(imageNamed: "gem_green_1", objectNamed: "greenGem")
    let redGem = Item(imageNamed: "gem_green_1", objectNamed: "redGem")
    let buttonEast = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonWest = SKSpriteNode(imageNamed: "Directional_Button2")
    let buttonNorth = SKSpriteNode(imageNamed: "Directional_Button")
    let menuButton = SKSpriteNode(imageNamed: "Key")
    let savePointButton = SKSpriteNode(imageNamed: "crystal")
    let teleportButton = SKSpriteNode(imageNamed: "crystal")
    
    //these are used for the scaleBackground method and setupBackground
//    let background = SKSpriteNode(imageNamed: "kz_egypt_3_background")
    let background = SKSpriteNode(imageNamed: "kz_caves_background")
    var backgroundYStart: CGFloat = 1.0
    var backgroundXScaleStart: CGFloat = 1.0
    var backgroundYScaleStart: CGFloat = 1.0
    var setup = false
    let maxScaleHeight: CGFloat = 100
    var currentPlayerHeight: CGFloat = 0
    
    //player spawn
    var playerSpawnPoint: CGPoint = CGPoint.zeroPoint
    
    //checking device type
    let modelName = UIDevice.currentDevice().modelName
    
    //particles
    let snowEmitter = SKEmitterNode(fileNamed: "Rain.sks")
    
    //physics in tiles
    var physicsUpdateFromPoint = CGPointMake(0.0, 0.0)
    
    //MARK: Setup Methods
    func setupMap() {
        //****NO****tileMap = SKATiledMap(fileNamed: "kz_egypt_3")
        //tileMap = JSTileMap(named: "\(currentMap).tmx")
        tileMap = SKATiledMap(mapName: currentMap)
        createBackground()
    }
    
    //testing multiple files in one map
    var mapOffsetX:CGFloat = 0
    var mapSectionsArray = [SKNode]()
    
    func setupPlayer() {
        worldNode.addChild(player)
        player.position = CGPointMake(55,235)
        player.zPosition = 200//-41
        //player.position = CGPointMake(955,2235)
        player.setScale(0.7)
        centerViewOn(player.position)
        player.physicsBody?.restitution = 0
        physicsUpdateFromPoint = player.position
        //player.setFalling(false)
    }

    func createWorld() {
        worldNode = SKNode()
        worldNode.addChild(tileMap)
        addChild(worldNode)
        //TMX LEGACY
        //setupTiles()
        tileMapFrame = tileMap.calculateAccumulatedFrame()
        if modelName == "iPhone 6" {
            if currentMap == "kz_wonderland"{
                snowEmitter.position = CGPointMake(self.view!.bounds.width / 2, self.view!.bounds.height)
                addChild(snowEmitter)
            }
        }
        
        anchorPoint = CGPointMake(0.5,0.5)
        worldNode.position = CGPointMake(-tileMapFrame.width / 2, -tileMapFrame.height / 2)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.contactDelegate = self
    }
    
    
    //need to make sure I'm not adding physics on top of physics 
    func cullPhysicsTiles() {
        let l = 3
        for var x = 0; x < Int(tileMap.mapWidth); x++ {
            for var y = 0; y < Int(tileMap.mapHeight); y++ {
                if x > 20 || y > 20 {
                    let sprite = tileMap.spriteOnLayer(l, indexX: x, indexY: y)
                    if sprite != nil {
                        sprite.hidden = false
                    }
                } else {
                    let sprite = tileMap.spriteOnLayer(l, indexX: x, indexY: y)
                    if sprite != nil {
                        sprite.hidden = false
                        sprite.alpha = 0
                        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.frame.size)
                        sprite.physicsBody?.dynamic = false
                        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Player
                        //sprite.physicsBody?.contactTestBitMask = SKACategoryPlayer
                        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Floor
                        //sprite.physicsBody?.categoryBitMask = SKACategoryFloor
                    }
                }
            }
        }
    }
    
    //MARK: SKAToolKit
    func loadObjects() {
        if tileMap.objectLayers.count > 0 {
            let layer = tileMap.objectLayers[0] as! SKAObjectLayer
            loadMapObjectsWithLayer(layer)
        }
    }
    
    func loadMapObjectsWithLayer(layer: SKAObjectLayer) {
        
        for object in layer.objects {
            let obj = object as! SKAObject
           //load the player
            if obj.name == "player" {
                player.position = CGPoint(x: obj.x, y: obj.y)
                //this spawn point is for use in the respawn method
                playerSpawnPoint = CGPoint(x: obj.x, y: obj.y)
                player.zPosition = 200
                player.setScale(0.7)
                worldNode.addChild(player)
                centerViewOn(player.position)
            } else if obj.name == "greenGem" {
                greenGem.position = CGPoint(x: obj.x, y: obj.y)
                greenGem.zPosition = 200
                greenGem.name = "greenGem"
                worldNode.addChild(greenGem)
            } else if obj.name == "redGem" {
                redGem.position = CGPoint(x: obj.x, y: obj.y)
                redGem.zPosition = 200
                redGem.name = "redGem"
                worldNode.addChild(redGem)
            }
        }
    }
    
    func cullTiles() {
        for var l = 0; l < Int(tileMap.spriteLayers.count); l++ {             for var x = 0; x < Int(tileMap.mapWidth)-1; x++ {
                for var y = 0; y < Int(tileMap.mapHeight)-1; y++ {
                    if x > 20 || y > 20 {
                        let sprite = tileMap.spriteOnLayer(l, indexX: x, indexY: y)
                        if sprite != nil {
                        sprite.hidden = true
                        }
                    }
                }
            }
        }
    }
    
    //TMX LEGACY
//    func setupTiles() {
//        for var a = 0; a < Int(tileMap.mapSize.width); a++ { //Go through every point across the tile map
//            for var b = 0; b < Int(tileMap.mapSize.height); b++ { //Go through every point up the tile map
//                let layerInfo:TMXLayerInfo = tileMap.layers.lastObject as! TMXLayerInfo //Get the first layer (you may want to pick another layer if you don't want to use the first one on the tile map)
//                let point = CGPoint(x: a, y: b)//Create a point with a and b
//                let gid = layerInfo.layer.tileGidAt(layerInfo.layer.pointForCoord(point)) //The gID is the ID of the tile. They start at 1 up the the amount of tiles in your tile set.
//                
//                //determining which tiles to act on
//                if gid == 383 || gid == 384 || gid == 385 || gid == 9 || gid == 11 || gid == 1{
//                    let left = player.position.x - 1500
//                    let right = player.position.x + 1500
//                    let up = player.position.y + 300
//                    let down = player.position.y - 700
//                
//                    let node = layerInfo.layer.tileAtCoord(point)
//                    if node != nil {
//                    physicsTiles.append(node)
//                    //I fetched a node at that point created by JSTileMap
//                    node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size) //I added a physics body
//                    if node.position.y > up {
//                        node.name = "inactive"
//                        node.physicsBody?.resting = true
//                    }
//                    node.physicsBody?.dynamic = false
//                    node.physicsBody?.restitution = 0
//                    //node.physicsBody?.resting = true
//                    if currentMap == "kz_wonderland" {
//                        node.physicsBody?.friction = 0.01
//                    } else {
//                        node.physicsBody?.friction = 5
//                    }
//                    node.alpha = 0
//                    node.name = "active"
//                    if gid == 1 {
//                        node.name = "physics"
//                        node.physicsBody?.categoryBitMask = PhysicsCategory.Bounce
//                        spawnParticles(node.position)
//                    } else {
//                        node.physicsBody?.categoryBitMask = PhysicsCategory.Floor
//                    }
//                    
//                    if gid == 11 {
//                    }
//                    node.physicsBody?.contactTestBitMask = PhysicsCategory.Player
//                    
//                    //println("added physics")
//                    //You now have a physics body on your floor tiles! :)
//                        }
//                    }
//                }
//            }
//            println(physicsTiles.count)
//        }
//    
    //TMX LEGACY
//    func hideLayer() {
//        let layerInfo1:TMXLayerInfo = tileMap.layers.firstObject as! TMXLayerInfo
//        let layerInfo2:TMXLayerInfo = tileMap.layers.objectAtIndex(1) as! TMXLayerInfo
//        let layerInfo3:TMXLayerInfo = tileMap.layers.objectAtIndex(2) as! TMXLayerInfo
//        let layerInfo4:TMXLayerInfo = tileMap.layers.objectAtIndex(3) as! TMXLayerInfo
//        //let layerInfo5:TMXLayerInfo = tileMap.layers.objectAtIndex(4) as! TMXLayerInfo
//        layerInfo1.layer.hidden = true
//        layerInfo2.layer.hidden = true
//        layerInfo3.layer.hidden = true
//        layerInfo4.layer.hidden = true
//        //layerInfo5.layer.hidden = true
//        //layerInfo1.tiles.destroy()
//    }
//
//    func setupOtherTiles() {
//        for var a = 0; a < Int(tileMap.mapSize.width); a++ { //Go through every point across the tile map
//            for var b = 0; b < Int(tileMap.mapSize.height); b++ { //Go through every point up the tile map
//                let layerInfo:TMXLayerInfo = tileMap.layers.firstObject as! TMXLayerInfo //Get the first layer (you may want to pick another layer if you don't want to use the first one on the tile map)
//                let point = CGPoint(x: a, y: b)
////                let left = player.position.x - 1500
////                let right = player.position.x + 1500
////                let up = player.position.y + 1000
////                let down = player.position.y - 1000
//                
//                let node = layerInfo.layer.tileAtCoord(point)
//                if node != nil {
//                    node.hidden = true
//                    //otherTileCoords.append(node.position)
//                    //println(otherTiles.count)
//                }
//            }
//        }
//    }

    
    //MARK: Tile Map Management
    var physicsTiles = [SKSpriteNode]()
    var otherTiles = [SKSpriteNode]()
    var otherTileCoords = [CGPoint]()
    
    
    func setupInterface() {
        let widthHalf:CGFloat = self.view!.bounds.width / 2
        let heightHalf:CGFloat = self.view!.bounds.height / 2
        
        

        
        addChild(buttonNorth)
        buttonNorth.position = CGPoint(x: widthHalf - (buttonNorth.size.width), y: -heightHalf + (buttonWest.size.height * 0.6))
        buttonNorth.zPosition = 200
        
        addChild(buttonWest)
        buttonWest.position = CGPoint(x: -widthHalf + buttonWest.size.width, y: -heightHalf + (buttonWest.size.height * 0.6))
        buttonWest.zPosition = 200
        
        addChild(buttonEast)
        buttonEast.position = CGPoint(x: buttonWest.position.x + (buttonWest.size.width * 2), y: buttonWest.position.y)
        buttonEast.xScale = -1
        buttonEast.zPosition = 200
        
        addChild(menuButton)
        menuButton.position = CGPoint(x: buttonWest.position.x, y: heightHalf - menuButton.size.height * 0.4)
        menuButton.zPosition = 200
        
        addChild(teleportButton)
        teleportButton.setScale(1.5)
        teleportButton.position = CGPoint(x: widthHalf / 4 , y: -heightHalf + (teleportButton.size.height * 1.1))
        teleportButton.yScale = -1.5
        teleportButton.alpha = 0.3
        teleportButton.zPosition = 200
        
        addChild(savePointButton)
        savePointButton.setScale(1.5)
        savePointButton.position = CGPoint(x: teleportButton.position.x - (teleportButton.size.width * 3), y: teleportButton.position.y)
        savePointButton.zPosition = 200
        
        
        //timer
        stopWatchLabel.fontSize = 15
        stopWatchLabel.name = "timer"
        stopWatchLabel.verticalAlignmentMode = .Center
        stopWatchLabel.position = CGPoint(x: buttonNorth.position.x, y: heightHalf - menuButton.size.height * 0.4)
        stopWatchLabel.zPosition = 200
        addChild(stopWatchLabel)
        
        
        savePointLabel.fontSize = 10
        savePointLabel.text = "Checkpoint Saved"
        savePointLabel.fontColor = SKColor.yellowColor()
        savePointLabel.name = "saved point"
        savePointLabel.zPosition = 200
        savePointLabel.verticalAlignmentMode = .Center
        savePointLabel.position = CGPoint(x: widthHalf / 14, y: -heightHalf + savePointLabel.frame.height * 4)
        savePointLabel.alpha = 0
        addChild(savePointLabel)
        

        savePointsRemainingLabel.fontSize = 20
        savePointsRemainingLabel.text = "\(savePointsRemaining)"
        //savePointsRemainingLabel.fontColor = SKColor.blueColor()
        savePointsRemainingLabel.name = "save points remaining"
        savePointsRemainingLabel.zPosition = savePointButton.zPosition + 1
        savePointsRemainingLabel.verticalAlignmentMode = .Center
        savePointsRemainingLabel.horizontalAlignmentMode = .Center
        savePointsRemainingLabel.position = CGPointMake(savePointButton.position.x, savePointButton.position.y + (savePointsRemainingLabel.frame.height * 0.15))
        savePointsRemainingLabel.alpha = 1
        addChild(savePointsRemainingLabel)
    }
    
    func createBackground() {
        //let background = SKSpriteNode(imageNamed: "\(currentMap)_background")
        let background = SKSpriteNode(imageNamed: "kz_caves_background")
        addChild(background)
        background.zPosition = -201
        background.setScale(2)
        background.name = "background"
        //let bgTexture = SKTexture(imageNamed: "kz_caves_background")
        let bgTexture = SKTexture(imageNamed: "\(currentMap)_background")
        //bgTexture.filteringMode = .Nearest
        background.texture = bgTexture
        background.position = CGPointMake(0, 100)
        backgroundYStart = background.position.y
        if currentMap == "kz_wonderland" {
            background.xScale = 9
            background.yScale = 8
            background.position = CGPointMake(0, 170)
            //println("wonderland setup")
        }
        if currentMap == "kz_egypt_2" {
            background.setScale(7)
            background.position = CGPointMake(0, 100)
        }
        if currentMap == "kz_dream" {
            background.xScale = 6
            background.yScale = 5
            background.position = CGPointMake(0, 0)
            
            let turnBlack = SKAction.colorizeWithColor(SKColor.blackColor(), colorBlendFactor: 0.7, duration: 3.0)
            let turnRed = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.8, duration: 3.0)
            let turnOrange = SKAction.colorizeWithColor(SKColor.orangeColor(), colorBlendFactor: 0.9, duration: 3.0)
            let turnPurple = SKAction.colorizeWithColor(SKColor.purpleColor(), colorBlendFactor: 0.9, duration: 3.0)
            let sequence = SKAction.sequence([turnOrange, turnBlack, turnRed, turnBlack, turnPurple, turnBlack])
            let repeat = SKAction.repeatActionForever(sequence)
            background.runAction(repeat)
            
        }
    }
    //MARK: Game Loop
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        setupMap()
        createWorld()
        //createWorldFromMaps()
        setupInterface()
        loadObjects()
        //setupPlayer()
        

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //delta
//        if lastUpdateTime > 0 {
//            dt = currentTime - lastUpdateTime
//        } else {
//            dt = 0
//        }
//        lastUpdateTime = currentTime
        //println("\(dt) is the dt")
        //end delta
        //centerViewOn(player.position)
//        let target = getCenterPointWithTarget(player.position)
//        worldNode.position += (target - worldNode.position) * 0.8
        
        player.update(CGFloat(dt))
        
//        //dead yet?
//        if player.position.y < -300 {
//            player.position = playerSpawnPoint
//        }
        
        
//        if player.physicsBody?.velocity.dy >= -75.0 || (player.physicsBody?.velocity.dy <= 30.0) && (player.physicsBody?.velocity.dy >= -20.0){//!= 0.0 {
//            player.setFalling(false)
//            if player.physicsBody?.velocity.dy != 0.0 {
//            }
//        } else {
//            player.setFalling(true)
//        }
//        scaleBackground(player.position.y)
//        let playerIndex = tileMap.indexForPoint(player.position)
//       tileMap.cullAroundIndexX(Int(playerIndex.x), indexY: Int(playerIndex.y), columnWidth: 50, rowHeight: 25)
    }
    
    //MARK: - Camera
    
//    func centerViewOn(centerOn: CGPoint) {
//        let x = centerOn.x.clamped(size.width / 2, tileMapFrame.width - size.width / 2)
//        let y = centerOn.y.clamped(size.height / 2, tileMapFrame.height - size.height / 2)
//        worldNode.position = CGPoint(x: -x, y: -y)
//    }
    
    func centerViewOn(centerOn: CGPoint) {
        worldNode.position = getCenterPointWithTarget(centerOn)
    }
    
    func getCenterPointWithTarget(target: CGPoint) -> CGPoint {
        let x = target.x.clamped(size.width / 2, tileMapFrame.width - size.width / 2)
        let y = target.y.clamped(size.height / 2, tileMapFrame.height - size.height / 2)
        
        return CGPoint(x: -x, y: -y)
    }
    
    func scaleBackground(yPosition: CGFloat) {
        //scale and position background according to player.position.y
        if !setup {
            backgroundYStart = background.position.y
            backgroundXScaleStart = background.xScale
            backgroundYScaleStart = background.yScale
            setup = true
        }
        if setup {
            var realPlayerHeight = (yPosition / 100)
            if realPlayerHeight > maxScaleHeight {
                realPlayerHeight = maxScaleHeight
            }
            //background.position = CGPointMake(1,1)
            //println(realPlayerHeight)
            var heightPercentage = maxScaleHeight - realPlayerHeight
            var regulatedPercentage = heightPercentage / 100
            if regulatedPercentage < 0.20 {
                regulatedPercentage = 0.20
            }
            //println(regulatedPercentage)
            background.position = CGPointMake(background.position.x , backgroundYStart * regulatedPercentage)
            //println(background.position)
            //background.xScale = backgroundXScaleStart * regulatedPercentage
            //background.yScale = backgroundYScaleStart * regulatedPercentage
        }
    }

    
    //MARK: - Stopwatch
    func stopTimer() {
        if stopWatchLabel.actionForKey("timer") != nil {
            //println("stopping timer")
            stopWatchLabel.removeActionForKey("timer")
        }
    }
    
    func startTimer() {
        var leadingZero = ""
        var leadingZeroMin = ""
        var timeMin = Int()
        var actionwait = SKAction.waitForDuration(1.0)
        var timesecond = Int()
        var actionrun = SKAction.runBlock({
            timeMin++
            timesecond++
            if timesecond == 60 {timesecond = 0}
            if timeMin  / 60 <= 9 { leadingZeroMin = "0" } else { leadingZeroMin = "" }
            if timesecond <= 9 { leadingZero = "0" } else { leadingZero = "" }
            
        self.stopWatchLabel.text = "[ \(leadingZeroMin)\(timeMin/60) : \(leadingZero)\(timesecond) ]"
        })
        self.stopWatchLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([actionrun, actionwait])), withKey: "timer")
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
            
            //touched right
            if (CGRectContainsPoint(eastFrame2, location)) {

                //temp
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
            }else if (CGRectContainsPoint(menuButton.frame, location)) {
                    
                //println("menu touched")
                let mapSelectScene = MapSelectScene(size: size)
                let reveal = SKTransition.fadeWithDuration(0.5)
                view?.presentScene(mapSelectScene, transition: reveal)
                
            }else if (CGRectContainsPoint(savePointButton.frame, location)) {
                //println("touched save button")
                saveCheckPoint()
            }else if (CGRectContainsPoint(teleportButton.frame, location)) {
                //println("touched teleport button")
                teleportToCheckPoint()
            //jumped
            } else {
                buttonNorth.texture = SKTexture(imageNamed: "Directional_Button_Lit")
                jumpButtonIsPressed = true
//experimenting with launching player
//                if player.isRunning && !player.isJumping{
//                    if player.xScale > 0 {
//                        player.physicsBody?.applyImpulse(CGVectorMake(50, 2))
//                        println("launch right")
//                    } else if player.xScale < 0 {
//                        player.physicsBody?.applyImpulse(CGVectorMake(-50, 2))
//                        println("launch left")
//                    }
//                }
                player.jump()
            }
        }
    }
    
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let eastFrame:CGRect = CGRectMake(buttonEast.position.x, buttonEast.position.y, buttonEast.frame.width * 2, buttonEast.frame.height * 2)
            let eastFrame2:CGRect = CGRectMake(buttonEast.position.x - (eastFrame.size.width / 2), buttonEast.position.y - (eastFrame.size.height / 2), buttonEast.frame.width * 2, buttonEast.frame.height * 2)
            
            let westFrame:CGRect = CGRectMake(buttonWest.position.x, buttonWest.position.y, buttonWest.frame.width * 2, buttonWest.frame.height * 2)
            let westFrame2:CGRect = CGRectMake(buttonWest.position.x - (westFrame.size.width / 2), buttonWest.position.y - (westFrame.size.height / 2), buttonWest.frame.width * 2, buttonWest.frame.height * 2)
            
            //touched right
            if (CGRectContainsPoint(eastFrame2, location)) {
                
                //currentState = MoveStates.E
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2_Lit")
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2")
                moveButtonIsPressed = true
                player.playerSpeedX = player.maxSpeed
                player.adjustXSpeedAndScale()
                player.startWalk()
                
                
                //touched left
            }  else if (CGRectContainsPoint(westFrame2, location)) {
                
                //currentState = MoveStates.W
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2_Lit")
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2")
                moveButtonIsPressed = true
                player.playerSpeedX = -player.maxSpeed
                player.adjustXSpeedAndScale()
                player.startWalk()
                
                
                //jumped
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
                player.physicsBody?.applyImpulse(CGVectorMake(10,0))
                //playerIdleSpeed(checkTileType(), direction: "right")
                moveButtonIsPressed = false
                buttonEast.texture = SKTexture(imageNamed: "Directional_Button2")
                buttonWest.texture = SKTexture(imageNamed: "Directional_Button2")
                //removeActionForKey("checking")
                //updateRunIntentions("stop")

            } else if (CGRectContainsPoint(westFrame2, location)) {
                //println("touch ended on left button")
                player.stopWalk()
                player.playerSpeedX = 0
                player.physicsBody?.applyImpulse(CGVectorMake(-10,0))
                //playerIdleSpeed(checkTileType(), direction: "left")
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
        }
    }
    
    //MARK: Physics Handling
    override func didFinishUpdate() {
        
        //used 50 and 25 before
        let playerIndex = tileMap.indexForPoint(player.position)
        tileMap.cullAroundIndexX(Int(playerIndex.x), indexY: Int(playerIndex.y), columnWidth: 50, rowHeight: 25)
        
        let target = getCenterPointWithTarget(player.position)
        worldNode.position += (target - worldNode.position) * 0.8
        
        scaleBackground(player.position.y)
    }
    
    override func didSimulatePhysics() {
    if player.physicsBody?.velocity.dy >= -75.0 || (player.physicsBody?.velocity.dy <= 30.0) && (player.physicsBody?.velocity.dy >= -20.0){//!= 0.0 {
            player.setFalling(false)
            if player.physicsBody?.velocity.dy != 0.0 {
        }
            } else {
            player.setFalling(true)
        }
        
        //dead yet?
        if player.position.y < -300 {
            player.position = playerSpawnPoint
        }
    }
    func didBeginContact(contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
//        if collision == PhysicsCategory.Player | PhysicsCategory.Bounce {
//            //println("hit bounce tile")
//            player.physicsBody?.applyImpulse(CGVectorMake(0,75))
//        }
        
        if collision == SKACategoryPlayer | PhysicsCategory.Item {
            let b = contact.bodyB.node?.name
            if b == "greenGem" {
                startTimer()
                greenGem.removeFromParent()
            } else if b == "redGem" {
                stopTimer()
                redGem.removeFromParent()
            }
        }

    }
    
    //MARK: Particles
    func spawnParticles(atPoint: CGPoint) {
        //println(modelName)
            let bounceEmitter = SKEmitterNode(fileNamed: "MagicFire.sks")
            bounceEmitter.position = atPoint
            bounceEmitter.zPosition = player.zPosition - 1
            worldNode.addChild(bounceEmitter)
        //println("spawned particles at \(atPoint)")
    }
    
    //MARK: Checkpoint System
    func teleportToCheckPoint(){
        if savePoint != CGPoint.zeroPoint {
            player.position = savePoint
        }
    }
    
    func saveCheckPoint(){
        if savePointsRemaining == 1 {
            savePointButton.alpha = 0.4
            savePointsRemainingLabel.alpha = 0
        }
        if savePointsRemaining > 0 {
        if player.physicsBody?.velocity.dy >= -75.0 || (player.physicsBody?.velocity.dy <= 20.0) && (player.physicsBody?.velocity.dy >= -10.0){
            savePointsRemaining -= 1
            savePointsRemainingLabel.text = "\(savePointsRemaining)"
            savePoint = player.position
            if teleportButton.alpha != 1 {
                teleportButton.alpha = 1
            }
            //fade the message in/out
            savePointLabel.runAction(SKAction.sequence([
                SKAction.fadeInWithDuration(0.5),
                SKAction.waitForDuration(0.5),
                SKAction.fadeOutWithDuration(0.5)
                ]))
            }
        }
    }
    
}
