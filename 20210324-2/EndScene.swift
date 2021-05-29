//
//  endScene.swift
//  20210324-2
//
//  Created by mac10 on 2021/4/8.
//  Copyright © 2021 mac10. All rights reserved.
//

import UIKit
import SpriteKit
var bgm : SKAudioNode!
class EndScene: SKScene {
    override  func didMove(to view: SKView) {
        createScene()
    }
    func createScene(){
        let bgd = SKSpriteNode(imageNamed: "gameover.jpg")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        bgd.zPosition = -1
        if let musicURL = Bundle.main.url(forResource: "Andas valiendo verga", withExtension: "mp3"){
            bgm = SKAudioNode(url: musicURL)
            addChild(bgm)
        }
        self.addChild(bgd)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let mainScene = MainScene(size: self.size)
        let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
        self.view?.presentScene(mainScene, transition: doors)

    }
}
