//
//  GameScene.swift
//  PeevedPenguins
//
//  Created by Akash Nambiar on 6/21/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /* Game object connections */
    var catapultArm: SKSpriteNode!
    var catapult: SKSpriteNode!
    var joint: SKSpriteNode!
    var touchNode: SKSpriteNode!
    var touchJoint: SKPhysicsJointSpring?
    var cameraNode: SKCameraNode!
    var cameraTarget: SKSpriteNode?
    var buttonRestart: MSButtonNode!
    var penguinJoint: SKPhysicsJointPin?
    var sealsKilled: SKLabelNode!
    var penguinsLaunched: SKLabelNode!
    var numLaunched = 0
    var numDeath = 0
    
    override func didMove(to view: SKView) {
        /* Set reference to catapultArm node */
        sealsKilled = childNode(withName: "//sealsKilled") as! SKLabelNode
        penguinsLaunched = childNode(withName: "//penguinsLaunched") as! SKLabelNode
        
        catapultArm = childNode(withName: "catapultArm") as! SKSpriteNode
        catapultArm.physicsBody?.usesPreciseCollisionDetection = true
        
        catapult = childNode(withName: "catapult") as! SKSpriteNode
        joint = childNode(withName: "joint") as! SKSpriteNode
        touchNode = childNode(withName: "touchNode") as! SKSpriteNode
        
        cameraNode = childNode(withName: "cameraNode") as! SKCameraNode
        self.camera = cameraNode
        
        buttonRestart = childNode(withName: "//buttonRestart") as! MSButtonNode
        buttonRestart.selectedHandler = {
            guard let scene = GameScene.level(1) else {
                print("Level 1 is missing?")
                return
            }
            
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
            
            self.numLaunched = 0
            self.penguinsLaunched.text = "Penguins Launched: \(self.numLaunched)"
            
            self.numDeath = 0
            self.sealsKilled.text = "Seals Killed \(self.numDeath)/5"

        }
        
        physicsWorld.contactDelegate = self
        
        setupCatapult()
    }
    
    func setupCatapult() {
//        catapultArm.physicsBody?.usesPreciseCollisionDetection = true
        
        var pinLocation = catapult.position
        pinLocation.x += -10
        pinLocation.y += -10
        let catapultJoint = SKPhysicsJointPin.joint(withBodyA:catapult.physicsBody!, bodyB: catapultArm.physicsBody!, anchor: pinLocation)
        physicsWorld.add(catapultJoint)
        
        var anchorAPosition = catapultArm.position
        anchorAPosition.x += 0
        anchorAPosition.y += 50
        let catapultSpringJoint = SKPhysicsJointSpring.joint(withBodyA: catapultArm.physicsBody!, bodyB: joint.physicsBody!, anchorA: anchorAPosition, anchorB: joint.position)
        physicsWorld.add(catapultSpringJoint)
        catapultSpringJoint.frequency = 6
        catapultSpringJoint.damping = 0.5
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        /* Get references to the bodies involved in the collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        /* Check if either physics bodies was a seal */
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            if contact.collisionImpulse >= 2.0{
                if contactA.categoryBitMask == 2 { removeSeal(node: nodeA) }
                if contactB.categoryBitMask == 2 { removeSeal(node: nodeB) }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if(cameraTarget != catapultArm){
//            catapultArm.physicsBody?.collisionBitMask = 1
//            resetCamera()
            cameraTarget = catapultArm
            
            return
        }

        let touch = touches.first!              // Get the first touch
        let location = touch.location(in: self) // Find the location of that touch in this view
        let nodeAtPoint = atPoint(location)     // Find the node at that location
        if nodeAtPoint.name == "catapultArm" {  // If the touched node is named "catapultArm" do...
            touchNode.position = location
            touchJoint = SKPhysicsJointSpring.joint(withBodyA: touchNode.physicsBody!, bodyB: catapultArm.physicsBody!, anchorA: location, anchorB: location)
            physicsWorld.add(touchJoint!)
        }
        
        let penguin = Penguin()
        addChild(penguin)
        penguin.position.x += catapultArm.position.x + 50
        penguin.position.y += catapultArm.position.y + 50
        penguin.physicsBody?.usesPreciseCollisionDetection = true
        penguinJoint = SKPhysicsJointPin.joint(withBodyA: catapultArm.physicsBody!, bodyB: penguin.physicsBody!, anchor: penguin.position)
        physicsWorld.add(penguinJoint!)
        cameraTarget = penguin
        
        numLaunched += 1
        penguinsLaunched.text = "Penguins Launched: \(numLaunched)"
        
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        touchNode.position = location
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchJoint = touchJoint {
            physicsWorld.remove(touchJoint)
        }
        
        if let penguinJoint = penguinJoint {
            physicsWorld.remove(penguinJoint)
        }
        
        guard let penguin = cameraTarget else {
            return
        }
        
        let force: CGFloat = 350
        let r = catapultArm.zRotation
        let dx = cos(r) * force
        let dy = sin(r) * force
        let d = CGVector(dx: dx, dy: dy)
        penguin.physicsBody?.applyForce(d)
        penguin.physicsBody?.affectedByGravity = true
        
//        catapultArm.physicsBody?.collisionBitMask = 0
        
        }
    
    /* Make a Class method to load levels */
    class func level(_ levelNumber: Int) -> GameScene? {
        guard let scene = GameScene(fileNamed: "Level\(levelNumber)") else {
            return nil
        }
        scene.scaleMode = .aspectFit
        return scene
    }
    
    func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }
    
    func moveCamera() {
        guard let cameraTarget = cameraTarget else {
            return
        }
        let targetX = cameraTarget.position.x
        let x = clamp(value: targetX, lower: 0, upper: 392
        )
        cameraNode.position.x = x
    }
    
    func removeSeal(node: SKNode) {
        let pooh = SKEmitterNode(fileNamed: "Smoke")!
        
        pooh.position = node.position
        addChild(pooh)
        
        let wait = SKAction.wait(forDuration: 5)
        let removePooh = SKAction.removeFromParent()
        pooh.run(SKAction.sequence([wait, removePooh]))
        
        let sound = SKAction.playSoundFileNamed("Explosion+1", waitForCompletion: false)
        self.run(sound)
        
        let sealDeath = SKAction.run ({
            node.removeFromParent()
        })
        self.run(sealDeath)
        
        numDeath += 1
        sealsKilled.text = "Seals Killed \(numDeath)/5"
    }
   
    func resetCamera() {
        /* Reset camera */
        let cameraReset = SKAction.move(to: CGPoint(x:0, y:camera!.position.y), duration: 1.5)
        let cameraDelay = SKAction.wait(forDuration: 0.5)
        let cameraSequence = SKAction.sequence([cameraDelay,cameraReset])
        cameraNode.run(cameraSequence)
        cameraTarget = nil
    }
    
    func checkPenguin() {
        guard let cameraTarget = cameraTarget else {
            return
        }
        
        if cameraTarget.physicsBody!.joints.count == 0 && cameraTarget.physicsBody!.velocity.length() < 0.18 {
            resetCamera()
        }
        
        if cameraTarget.position.y < -200 {
            cameraTarget.removeFromParent()
            moveCamera()
        }
    }
    
    func checkScore() {
        if numDeath == 5{
            
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        checkPenguin()
        moveCamera()

    }

}
extension CGVector {
    public func length() -> CGFloat{
        return ((sqrt(dx*dx) + (dy*dy)))
    }
}
