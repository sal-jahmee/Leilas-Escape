//
//  PotionScene.swift
//  Game
//
//  Created by Shakira Al-Jahmee on 2/18/25.
//

//
//  PotionScene.swift
//  Game
//
//  Created by Linda Swanson on 2/18/25.
//

import SpriteKit
import GameplayKit



class ThePotionScene: SKScene {
    
    var background: SKSpriteNode!
    var backgroundMusic: SKAudioNode!// Linda - Paul Hudson's way of adding audio
    var princess: SKSpriteNode!
    let princessFootStepSounds = SKAudioNode(fileNamed: "realstep")    // LINDA 2/20/25 realstep is 2 steps

    var wisp: SKSpriteNode!
    var hearts: SKSpriteNode!
    var leftArrowButton: SKSpriteNode!
    var rightArrowButton: SKSpriteNode!
    var dialogueBox2: SKSpriteNode!

    var isLeftArrowButtonPressed = false
    var isRightArrowButtonPressed = false
    
    let skeletonPosition = CGPoint(x: -20, y: -50)
    let proximityThreshold: CGFloat = 50
    
    //Shakira - initialized arrays for princess animation
    var idleFrames: [SKTexture] = []
    var walkFrames: [SKTexture] = []
    
    var hasVibrated = false
    var initialDialogs = ["dialog_10"]
    var secondaryDialogs = ["dialog_11", "dialog_12", "dialog_13", "dialog_14"]
    var currentDialogIndex = 0
    var dialogView: UIImageView?
    var isShowingInitialDialogs = true
    var hasReachedSkeleton = false

    func showDialog() {
        guard let sceneView = view else { return }
        let dialogImages = isShowingInitialDialogs ? initialDialogs : secondaryDialogs
        guard currentDialogIndex < dialogImages.count else { return }

        let imageName = dialogImages[currentDialogIndex]
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)

        let dialogWidth: CGFloat = sceneView.bounds.width * 0.5
        let dialogHeight: CGFloat = sceneView.bounds.height * 0.3
        let xPosition = (sceneView.bounds.width - dialogWidth) / 2
        let yPosition = sceneView.bounds.height * 0.7

        imageView.frame = CGRect(x: xPosition, y: yPosition, width: dialogWidth, height: dialogHeight)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageView.addGestureRecognizer(tapGesture)

        sceneView.addSubview(imageView)
        dialogView = imageView
    }

    @objc func handleTap() {
        let dialogImages = isShowingInitialDialogs ? initialDialogs : secondaryDialogs
        currentDialogIndex += 1

        if currentDialogIndex < dialogImages.count {
            dialogView?.removeFromSuperview()
            showDialog()
        } else {
            dialogView?.removeFromSuperview()
            dialogView = nil
            
            if !hasReachedSkeleton {
                isShowingInitialDialogs = false
            } else {
                proceedToNextLevel()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        showDialog()

        let candle = Candle(position: CGPoint(x: size.width / 2, y: size.height / 2))        //Shakira- added candle Animation
        addChild(candle)

       
        //pot
        let potionPot = PotionPot(position: CGPoint(x: size.width / 2, y: size.height / 2))
        addChild(potionPot)

        // Linda - Paul Hudson's way of adding background music
        if let musicURL = Bundle.main.url(forResource: "backgroundMusicGamePlay", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }

        // Shakira -  Add Princess node
        princess = SKSpriteNode(imageNamed: "idle")
        princess.texture?.filteringMode = .nearest
        princess.position = CGPoint(x: -280, y: -26)
        princess.zPosition = 1
        princess.xScale = 1.75
        princess.yScale = 1.75
        addChild(princess)
        // Shakira -  load Princess animation
        idleFrames = [SKTexture(imageNamed: "idle")]
        walkFrames = [
            SKTexture(imageNamed: "phase_1"),
            SKTexture(imageNamed: "phase_2"),
            SKTexture(imageNamed: "phase_3"),
            SKTexture(imageNamed: "phase_4"),
            SKTexture(imageNamed: "phase_5"),
            SKTexture(imageNamed: "phase_6")
        ].map { texture in
            texture.filteringMode = .nearest
            return texture}
        
        //wisp node
        wisp = SKSpriteNode(imageNamed: "wisp.png")
        wisp.position = CGPoint(x: -30, y: 0)
        //shakira- added scaling
        wisp.xScale = 0.5
        wisp.yScale = 0.5
        addChild(wisp)
        

        
        leftArrowButton = SKSpriteNode(imageNamed: "leftarrowbutton")
        leftArrowButton.position = CGPoint(x: -270, y: -110)
        leftArrowButton.zPosition = 2
        addChild(leftArrowButton)
        
        rightArrowButton = SKSpriteNode(imageNamed: "rightarrowbutton")
        rightArrowButton.position = CGPoint(x: 290, y: -110)
        rightArrowButton.zPosition = 2
        addChild(rightArrowButton)
        
        dialogueBox2 = SKSpriteNode(imageNamed: "dialoguebox2.png")
        dialogueBox2.position = CGPoint(x: -20, y: -115)
        dialogueBox2.zPosition = 3
        dialogueBox2.alpha = 0
        dialogueBox2.xScale = 0.15
        dialogueBox2.yScale = 0.15
        addChild(dialogueBox2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isLeftArrowButtonPressed {
            movePrincessLeft()
        }
        if isRightArrowButtonPressed {
            movePrincessRight()
        }
        let distanceToSkeleton = sqrt(pow(princess.position.x - skeletonPosition.x, 2) +
                                      pow(princess.position.y - skeletonPosition.y, 2))
        if distanceToSkeleton < proximityThreshold && !hasReachedSkeleton {
            hasReachedSkeleton = true
            currentDialogIndex = 0
            showDialog()
        }
    }
    func movePrincessLeft() {
            if princess.position.x - princess.size.width / 2 > -size.width / 2 {
                princess.position.x -= 2.5
                //Shakira - flip princess instead of flippinf frames manually
                princess.xScale = -1.75 // Flip left
    
                //shakira - haptic feedback
                triggerHapticFeedback()
    
                //shakira - when to use animation
                if princess.action(forKey: "walking") == nil { // Only start if not already playing
                    princess.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.1)), withKey: "walking")
                    // LINDA 2/19/25: New, merge
                    playPrincessFootSteps()
                }
            }
        }
    
        func movePrincessRight() {
            if princess.position.x + princess.size.width / 2 < size.width / 2 {
                princess.position.x += 2.5
                princess.xScale = 1.75
    
                //shakira - haptic feedback
                triggerHapticFeedback()
    
                //when to use animation
                if princess.action(forKey: "walking") == nil { // Only start if not already playing
                    princess.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.1)), withKey: "walking")
                    // LINDA 2/19/25: New, merge
                    playPrincessFootSteps()
                }
            }
        }
        func triggerHapticFeedback() {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
    //    // LINDA 2/20/25

    func playPrincessFootSteps() {
          // This made a galloping sound, because "walking" has 4 steps and each time the arrow is clicked, it would play over previous step audio
          // let princessFootStepSounds = SKAudioNode(fileNamed: "walking")
          //run(SKAction.playSoundFileNamed("footstep", waitForCompletion: true))
          princessFootStepSounds.autoplayLooped = true
          addChild(princessFootStepSounds)
          // Because addChild is within a function that gets called numerous times, you have to remove from parent upon touchesEnded or it crashes the next time the arrow button is clicked.
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           isLeftArrowButtonPressed = false
           isRightArrowButtonPressed = false
   
           handleTouches(touches, isTouching: true)
   
           for touch in touches {
               let touchLocation = touch.location(in: self)
   
               // LINDA: changed, merge
               if dialogueBox2.alpha == 1 && dialogueBox2.contains(touchLocation) {
                   proceedToNextLevel()
   
               }
   
               if leftArrowButton.contains(touchLocation) {
                   movePrincessLeft()
               } else if rightArrowButton.contains(touchLocation) {
                   movePrincessRight()
               }
           }
       }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            handleTouches(touches, isTouching: false)
            princess.removeAction(forKey: "walking")
            princess.texture = SKTexture(imageNamed: "idle")
            princess.texture?.filteringMode = .nearest
    
            // LINDA 2/20/25
            // This just does footsteps once, doesn't handle if you hold down blue arrow.
            //playPrincessFootSteps()
            //princessFootStepSounds.isPaused = true
            // Have to addchild during playPrincessFootSteps, so have to manually remove it otherwise it crashes on 2nd arrow click.
            princessFootStepSounds.removeFromParent()
        }
        func handleTouches(_ touches: Set<UITouch>, isTouching: Bool) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
    
                if leftArrowButton.contains(touchLocation) {
                    isLeftArrowButtonPressed = isTouching
                }
    
                else if rightArrowButton.contains(touchLocation) {
                    isRightArrowButtonPressed = isTouching
                }
            }
        }
    // LINDA: changed, merge
    func proceedToNextLevel() {
        // Linda door opening sound
        run(SKAction.playSoundFileNamed("doorOpen_HV.209.wav", waitForCompletion: true))

        // Load the next scene
        if let nextScene = SKScene(fileNamed: "TheThroneScene") {
            nextScene.scaleMode = .aspectFill

            // Apply nearest-neighbor filtering to all SKSpriteNodes
            for node in nextScene.children {
                if let spriteNode = node as? SKSpriteNode {
                    spriteNode.texture?.filteringMode = .nearest
                }
            }

            // Transition to new scene
            self.view?.presentScene(nextScene, transition: SKTransition.fade(withDuration: 0.5))
        }
    }

}
