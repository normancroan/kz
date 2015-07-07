//
//  GameViewController.swift
//  KZ
//
//  Created by Norman Croan on 5/30/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        let scene = MapSelectScene(size: CGSize(width: 2048, height: 1536))

        //skView.showsFPS = true
        skView.frameInterval = 2
        //skView.showsNodeCount = true
        //skView.showsPhysics = true
        //skView.showsDrawCount = true
        skView.ignoresSiblingOrder = true
        //skView.showsQuadCount = true
        /* Set the scale mode to scale to fit the window */
        scene.size = skView.bounds.size
        scene.scaleMode = .AspectFit
        //scene.currentMap = "kz_egypt"
        skView.presentScene(scene)

        

//        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
//            // Configure the view.
//            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            //skView.showsPhysics = true
//            //REMOVE IF UNWANTED BEHAVIOR ENSUES FROM FPS DROP
//            //skView.frameInterval = 2
//            
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.size = skView.bounds.size
//            //CHANGE TO FILL IF MESSED UP
//            scene.scaleMode = .AspectFit
//            //scene.currentMap = "kz_egypt"
//            skView.presentScene(scene)
//            
//        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
