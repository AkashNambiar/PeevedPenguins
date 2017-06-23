//
//  MainMenu.swift
//  PeevedPenguins
//
//  Created by Akash Nambiar on 6/21/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    /* UI Connections */
    var playButton: MSButtonNode!
    
    func loadGame() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = GameScene.level(1) else {
            print("Could not load GameScene with level 1")
            return
        }
        
        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFit
        
        /* Show debug */
//        skView.showsPhysics = true
//        skView.showsDrawCount = true
//        skView.showsFPS = true
        
        /* 4) Start game scene */
        skView.presentScene(scene)
    }
    
    func loadLevels() {
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }

        guard let scene = GameScene(fileNamed: "LevelMenu") else {
//            return nil
        }
        scene.scaleMode = .aspectFit
        return scene
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        
        playButton.selectedHandler = {
//            self.loadGame()
            self.loadLevels()
        }
        
    }
}
