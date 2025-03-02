//
//  GameViewController.swift
//  Game
//
//  Created by Saeed Mohamed on 2/3/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            let scene = GameMenuScene(size: CGSize(width: 1536, height: 2048))//points to skscene
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
//                let background = scene.childNode(withName: "background") as! SKSpriteNode
//                background.texture?.filteringMode = .nearest
                
                // Present the scene
    
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
        
    }
}
