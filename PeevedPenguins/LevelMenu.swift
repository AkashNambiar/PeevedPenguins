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
    var l3: MSButtonNode!
    var l4: MSButtonNode!
    var l5: MSButtonNode!
    var l6: MSButtonNode!
    var l7: MSButtonNode!
    var l8: MSButtonNode!
    var l9: MSButtonNode!
    static var level = 1
    
    override func didMove(to view: SKView) {
        
        l1 = self.childNode(withName: "l1") as! MSButtonNode
        l2 = self.childNode(withName: "l2") as! MSButtonNode
        l3 = self.childNode(withName: "l3") as! MSButtonNode
        l4 = self.childNode(withName: "l4") as! MSButtonNode
        l5 = self.childNode(withName: "l5") as! MSButtonNode
        l6 = self.childNode(withName: "l6") as! MSButtonNode
        l7 = self.childNode(withName: "l7") as! MSButtonNode
        l8 = self.childNode(withName: "l8") as! MSButtonNode
        l9 = self.childNode(withName: "l9") as! MSButtonNode
        
        l1.selectedHandler = {
            LevelMenu.level = 1
             self.load()
        }
        
        l2.selectedHandler = {
           LevelMenu.level = 2
            self.load()
        }
       
        l3.selectedHandler = {
            LevelMenu.level = 3
            self.load()
        }
        
        l4.selectedHandler = {
            LevelMenu.level = 4
            self.load()
        }
       
        l5.selectedHandler = {
            LevelMenu.level = 5
            self.load()
        }
        
        l6.selectedHandler = {
            LevelMenu.level = 6
            self.load()
        }
        
        l7.selectedHandler = {
            LevelMenu.level = 7
            self.load()
        }
        
        l8.selectedHandler = {
            LevelMenu.level = 8
            self.load()
        }

        l9.selectedHandler = {
            LevelMenu.level = 9
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
        guard let scene = GameScene.level(LevelMenu.level) else {
            print("Could not load GameScene with level \(LevelMenu.level)")
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

}
