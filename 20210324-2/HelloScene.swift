//
//  HelloScene.swift
//  20210324-2
//
//  Created by mac10 on 2021/3/24.
//  Copyright © 2021 mac10. All rights reserved.
//

import UIKit
import SpriteKit

class HelloScene: SKScene {
    override  func didMove(to view: SKView) {
        createScene()
    }
    var bgm : SKAudioNode!
    func createScene(){
        let bgd = SKSpriteNode(imageNamed: "hellobgd.jpg")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        bgd.zPosition = -1
        if let musicURL = Bundle.main.url(forResource: "Fantasy_Game_Fairy_Dust_C", withExtension: "wav"){
            bgm = SKAudioNode(url: musicURL)
            addChild(bgm)
        }
        let hellolabel = SKLabelNode(text: "Space 🥕 A🈹venture")
        hellolabel.name = "label"
        hellolabel.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        hellolabel.fontName = "AVenir-Oblique"
        hellolabel.fontSize = 28
        
        self.addChild(bgd)
        self.addChild(hellolabel)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let labelNode = self.childNode(withName: "label")
        let moveUp = SKAction.moveBy(x: 0, y: 200, duration: 1)
        let zoomIn = SKAction.scale(to: 3.0, duration: 1)
        let pause = SKAction.wait(forDuration: 0.5)
        let zoomOut = SKAction.scale(to: 0.5, duration: 0.25)
        let fadeway = SKAction.fadeOut(withDuration: 0.25)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveUp , zoomIn ,pause, zoomOut,pause,fadeway,remove])
        labelNode?.run(moveSequence, completion: {
            let mainScene = MainScene(size: self.size)
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
            self.view?.presentScene(mainScene, transition: doors)
        })
    }
}
