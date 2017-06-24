//
//  LevelMenu.swift
//  PeevedPenguins
//
//  Created by Akash Nambiar on 6/23/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class LevelMenu: SKScene {
    
    var l1: MSButtonNode!
    var l2: MSButtonNode!
    var level = 1
    
    override func didMove(to view: SKView) {
        
        l1 = self.childNode(withName: "l1") as! MSButtonNode
        l2 = self.childNode(withName: "l2") as! MSButtonNode
        
        l1.selectedHandler = {
          self.level = 1
             self.load()
        }
        
        l2.selectedHandler = {
           self.level = 2
            self.load()
        }
       
    }
    
    func load() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = GameScene.level(level) else {
            print("Could not load GameScene with level \(level)")
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

    func getLevel() -> Int{
        return level
    }
}
