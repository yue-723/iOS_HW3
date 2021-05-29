//
//  MainScene.swift
//  20210324-2
//
//  Created by mac10 on 2021/3/24.
//  Copyright © 2021 mac10. All rights reserved.
//

import UIKit
import SpriteKit

class MainScene: SKScene,SKPhysicsContactDelegate {
    var score = 0
    override func didMove(to view: SKView) {
        createScenee()
        let panrecognizer = UIPanGestureRecognizer(target: self, action: #selector(handpan))
        view.addGestureRecognizer(panrecognizer)
        physicsWorld.contactDelegate = self
    }
    var bgm : SKAudioNode!
    func createScenee(){
        if let musicURL = Bundle.main.url(forResource: "超跑情人夢", withExtension: "mp3"){
            bgm = SKAudioNode(url: musicURL)
            addChild(bgm)
        }
        let mainbgd = SKSpriteNode(imageNamed: "mainbgd.png")
        mainbgd.size.width = self.size.width
        mainbgd.size.height = self.size.height
        mainbgd.position = CGPoint(x: self.frame.midX,y:self.frame.midY)
        mainbgd.zPosition = -1
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
        let spaceship = newSpaceship()
        spaceship.position = CGPoint(x: self.frame.midX ,y:self.frame.midY-150)
        self.addChild(mainbgd)
        self.addChild(spaceship)
        
        let scorelabel = SKLabelNode(text: "Score: 0")
        scorelabel.name = "scorelabel"
        scorelabel.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY - 400)
        scorelabel.fontColor = SKColor.yellow
        scorelabel.fontName = "AVenir-Oblique"
        scorelabel.fontSize = 30
        self.addChild(scorelabel)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(newBullet), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(newRock), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(newCoin), userInfo: nil, repeats: true)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()

        

        if contact.bodyA.node?.name == "ships"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.node?.name == "ships" && secondBody.node?.name == "rocks"){
            print("You are loser!\n")
            Died()
        }else if (firstBody.node?.name == "ships" && secondBody.node?.name == "coins"){
            contact.bodyB.node?.removeFromParent()
            self.score += 100
            let scorelabel = self.childNode(withName: "scorelabel") as! SKLabelNode
            scorelabel.text = "Score: \(score)"
            print("Get point 100!\n")
        }
        if contact.bodyA.node?.name == "bullets"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.node?.name == "bullets" && secondBody.node?.name == "rocks"){
            secondBody.node?.removeFromParent()
        }else if (firstBody.node?.name == "bullets" && secondBody.node?.name == "coins"){
            secondBody.node?.removeFromParent()
        }
    }
    func  didEnd(_ contact: SKPhysicsContact) {
        print("didEnd")
    }
    func Died() {
        let endScene = EndScene(size: self.size)
        let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
        self.view?.presentScene(endScene, transition: doors)
        let alert = UIAlertController(title: "Score \(score)", message: "", preferredStyle: .alert)
        let againAction = UIAlertAction(title: "Again", style: .default, handler: nil)
        alert.addAction(againAction)
        self.view?.window?.rootViewController?.present(alert,animated: true,completion: nil)

    }
    func newSpaceship() -> SKSpriteNode{
        let ship = SKSpriteNode(imageNamed: "spaceship.png")
        ship.size = CGSize(width: 75, height: 75)
        ship.name = "ships"
        
        let leftlight = newLight()
        leftlight.position = CGPoint(x: -20, y: 6)
        ship.addChild(leftlight)
        
        let rightlight = newLight()
        rightlight.position = CGPoint(x: 20, y: 6)
        ship.addChild(rightlight)
        
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.width / 2)
        ship.physicsBody?.usesPreciseCollisionDetection = true
        ship.physicsBody?.isDynamic = false
        ship.physicsBody?.categoryBitMask = 0x1 << 1
        ship.physicsBody?.contactTestBitMask = 0x1 << 2

        return ship
    }
    func newLight() -> SKShapeNode{
        
        let light = SKShapeNode()
        light.path = CGPath(rect: CGRect(x: -2 ,y: -4,width: 4,height: 8), transform: nil)
        light.strokeColor = SKColor.white
        light.fillColor = SKColor.yellow
        
        let blink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25) ,
            SKAction.fadeIn(withDuration: 0.25)
        ])
        
        let blink4ever = SKAction.repeatForever(blink)
        light.run(blink4ever)
        
        return light
    }
    @objc func newBullet() {
        let bullet = SKShapeNode()
        //let h = self.size.height
        bullet.path = CGPath(rect: CGRect(x: -2 ,y: -4,width: 10,height: 10), transform: nil)
        bullet.strokeColor = SKColor.white
        bullet.fillColor = SKColor.red
        
        bullet.position = CGPoint(x: self.childNode(withName: "ships")!.position.x, y: self.childNode(withName: "ships")!.position.y)
        bullet.name = "bullets"
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.isDynamic = false
        let shotting = SKAction.move(by: CGVector(dx: 0, dy: 1000), duration: 3)
        
        bullet.physicsBody?.categoryBitMask = 0x1 << 3
        bullet.physicsBody?.contactTestBitMask = 0x1 << 2
        bullet.run(shotting)
        self.addChild(bullet)
    }
    @objc func newRock() {
        let rock = SKSpriteNode(imageNamed: "rock.png")
        rock.size = CGSize(width: 40, height: 40)
        let remove = SKAction.sequence([
            SKAction.wait(forDuration: 5) ,
            SKAction.removeFromParent()
        ])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        rock.position = CGPoint(x: x, y: h)
        rock.name = "rocks"
        rock.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        rock.physicsBody?.usesPreciseCollisionDetection = true
        rock.physicsBody?.categoryBitMask = 0x1 << 2
        rock.physicsBody?.contactTestBitMask = 0x1 << 1
        rock.run(remove)
        self.addChild(rock)
    }
    @objc func newCoin() {
        let coin = SKSpriteNode(imageNamed: "coin.png")
        coin.size = CGSize(width: 30, height: 30)
        let remove = SKAction.sequence([
            SKAction.wait(forDuration: 5) ,
            SKAction.removeFromParent()
        ])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        coin.position = CGPoint(x: x, y: h)
        coin.name = "coins"
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        coin.physicsBody?.usesPreciseCollisionDetection = true
        coin.physicsBody?.categoryBitMask = 0x1 << 2
        coin.physicsBody?.contactTestBitMask = 0x1 << 1
        coin.run(remove)
        self.addChild(coin)
    }
    @objc func handpan(recognizer: UIPanGestureRecognizer){
        let viewLocation = recognizer.location(in: view)
        let sceneLocation = convertPoint(toView: viewLocation)
        let moveToX = SKAction.moveTo(x: sceneLocation.x, duration: 0.1)
        let moveToY = SKAction.moveTo(y: sceneLocation.y, duration: 0.1)
        self.childNode(withName: "ships")!.run(moveToX)
        self.childNode(withName: "ships")!.run(moveToY)
    }
}
