//
//  GameScene.swift
//  InverseKinematics
//
//  Created by Ilya B Macmini on 28/03/2020.
//  Copyright © 2020 ilyabiltuev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var shadow: SKNode!

    var lowerTorso: SKNode!
    var upperTorso: SKNode!

    var leftUpperArm: SKNode!
    var leftLowerArm: SKNode!
    var leftFist: SKNode!
    
    var rightUpperArm: SKNode!
    var rightLowerArm: SKNode!
    var rightBack: SKNode!
    
    // Default rotation positions
    let rightUpperArmAngleDeg: CGFloat = 22
    let rightLowerArmAngleDeg: CGFloat = 101
    let leftUpperArmAngleDeg: CGFloat = -22
    let leftLowerArmAngleDeg: CGFloat = -101
    
    override func didMove(to view: SKView) {
        
        lowerTorso = childNode(withName: "torso_lower")
        lowerTorso.position = CGPoint(x: frame.midX, y: frame.midY - 30)
        
        shadow  = childNode(withName: "shadow")
        shadow.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        
        upperTorso = lowerTorso.childNode(withName: "torso_upper")
        
        leftUpperArm = upperTorso.childNode(withName: "arm_upper_front")
        leftLowerArm = leftUpperArm.childNode(withName: "arm_lower_front")
        leftFist = leftLowerArm.childNode(withName: "fist_front")
        
        rightUpperArm = upperTorso.childNode(withName: "arm_upper_back")
        rightLowerArm = rightUpperArm.childNode(withName: "arm_lower_back")
        rightBack = rightLowerArm.childNode(withName: "fist_back")
    }
    
    func rightPunchAt(_ location: CGPoint) {
        
        let punch = SKAction.reach(to: location, rootNode: rightUpperArm, duration: 0.1)
        
        let restore = SKAction.run {

            self.rightUpperArm.run(SKAction.rotate(toAngle: self.rightUpperArmAngleDeg.degreesToRadians(), duration: 0.3))
            self.rightLowerArm.run(SKAction.rotate(toAngle: self.rightLowerArmAngleDeg.degreesToRadians(), duration: 0.3))
        }

        rightBack.run(SKAction.sequence([punch, restore]))
    }
    
    func leftPunchAt(_ location: CGPoint) {
        
        let punch = SKAction.reach(to: location, rootNode: leftUpperArm, duration: 0.1)
        
        let restore = SKAction.run {
            
            self.leftUpperArm.run(SKAction.rotate(toAngle: self.leftUpperArmAngleDeg.degreesToRadians(), duration: 0.3))
            self.leftLowerArm.run(SKAction.rotate(toAngle: self.leftLowerArmAngleDeg.degreesToRadians(), duration: 0.3))
        }
        
        leftFist.run(SKAction.sequence([punch, restore]))
    }
    
    func punchAt(_ location: CGPoint) {
        
        if location.x > lowerTorso.position.x {
            
            rightPunchAt(location)
            
        } else {
            
            leftPunchAt(location)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Touches
        for touch: AnyObject in touches {
            
            let location = touch.location(in: self)
            
            punchAt(location)
        }
    }
    
    /*
     
     Basic project setup. May be useful
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    */
}
