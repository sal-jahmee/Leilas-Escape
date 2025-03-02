//
//  MenuView.swift
//  Game
//
//  Created by Saeed Mohamed on 2/19/25.
//

import SpriteKit
import GameplayKit

class GameMenuScene: SKScene {
    
    var GameMenu: SKSpriteNode!
    // Linda - Paul Hudson's way of adding audio
    var backgroundMusic: SKAudioNode!

    
    override func didMove(to view: SKView) {
        // Create and position the GameMenu sprite
        GameMenu = SKSpriteNode(imageNamed: "gameMenuHorizontal")
        //linda
        GameMenu.size = CGSize(width: 1658, height: 756)
        GameMenu.position = CGPoint(x: size.width/2, y: size.height/2)
        GameMenu.zPosition = 3
        addChild(GameMenu)
        
        // Linda - Paul Hudson's way of adding background music
        if let musicURL = Bundle.main.url(forResource: "backgroundMusicMainMenuExtended", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop through all touches to check where the user tapped
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            // Check if the touch is within the GameMenu node
            if GameMenu.contains(touchLocation) {
                // Proceed to the game scene
                proceedToGameScene()
            }
        }
    }
    
    func proceedToGameScene() {
        // Linda door opening sound
        run(SKAction.playSoundFileNamed("doorOpen_HV.209.wav", waitForCompletion: true))

        if let gameScene = SKScene(fileNamed: "GameScene") {
            gameScene.scaleMode = .aspectFill
            // Apply nearest filtering to all sprite nodes
                  gameScene.enumerateChildNodes(withName: "//.*") { node, _ in
                      if let spriteNode = node as? SKSpriteNode {
                          spriteNode.texture?.filteringMode = .nearest
                      }
                  }
            self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.5))
        }
    }
}

