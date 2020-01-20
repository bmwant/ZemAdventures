//
//  GameScene.swift
//  ZemAdventures
//
//  Created by Misha Behersky on 1/17/20.
//  Copyright © 2020 Misha Behersky. All rights reserved.
//

import SpriteKit
import GameplayKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

class GameScene: SKScene {
    
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    private var zem: SKSpriteNode!
    private var joystick: AnalogJoystick!
    
    
    override func didMove(to view: SKView) {

//        self.backgroundColor = UIColor(rgb: 0x76EEF6)
        setupCharacter()
        setupJoystick()

    }
    
    private func setupCharacter() {
        let zemTexture = SKTexture(imageNamed: "zem.png")
        zem = SKSpriteNode(texture: zemTexture)
        zem.physicsBody = SKPhysicsBody(texture: zemTexture, size: zemTexture.size())
        zem.physicsBody?.isDynamic = true
        zem.physicsBody?.allowsRotation = false
        zem.physicsBody?.affectedByGravity = true
        zem.scale(to: CGSize(width: zem.size.width*8, height: zem.size.height*8))
        zem.position = CGPoint(x: 300, y: 500)
        addChild(zem)
    }
    private func setupJoystick() {
        joystick = AnalogJoystick(diameter: 200, images: (UIImage(named: "jSubstrate"), UIImage(named: "jStick")))
        joystick.position = CGPoint(x: 200, y: 150)
        joystick.zPosition = 100
        joystick.alpha = 0.7
//        joystick.beginHandler = { [unowned self] in
//          print("begin")
//        }

        joystick.trackingHandler = { [unowned self] data in
            print(data.velocity.x, data.velocity.y)
            let newX: CGFloat = self.zem.position.x + data.velocity.x
            let newY: CGFloat = self.zem.position.y
            let newPoint = CGPoint(x: newX, y: newY)
            self.moveZem(to: newPoint)
        }

        joystick.stopHandler = { [unowned self] in
            self.zem.removeAllActions()
        }
        addChild(joystick)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func moveZem(to: CGPoint) {
        let moveAction = SKAction.move(to: to, duration: 0.5)
        zem.run(moveAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            var dx: CGFloat = 0
            var dy: CGFloat = 0
            for node in touchedNode {
                switch node.name {
                case "buttonUp":
                    dy = 80
                case "buttonDown":
                    dy = -80
                case "buttonLeft":
                    dx = -80
                case "buttonRight":
                    dx = 80
                default:
                    break
                }
            }
            var newX: CGFloat = zem.position.x + dx
            var newY: CGFloat = zem.position.y + dy
            var newPoint = CGPoint(x: newX, y: newY)
            moveZem(to: newPoint)
        }
    }
}
