//
//  spider.swift
//  Game
//
//  Created by Shakira Al-Jahmee on 2/18/25.
//
import SpriteKit

class Spider: SKSpriteNode {
    
    var spiderAnimation: SKAction!

    init(screenSize: CGSize) {
        let texture = SKTexture(imageNamed: "spider_1") // First frame as placeholder
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = "spider"
        
        // Scale the spider 5x
        
        self.xScale = 1.0
        self.yScale = 1.0

        // Center the spider in the middle of the screen
        self.position = CGPoint(x: -110, y: 38.2)

        // Ensure texture filtering is set to nearest to prevent glitches
        texture.filteringMode = .nearest

        // Load animation frames
        spiderAnimation = createSpiderAnimation()
        
        // Start the animation loop
        self.run(SKAction.repeatForever(spiderAnimation))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSpiderAnimation() -> SKAction {
        var frames: [SKTexture] = []

        // Load frames named "spider_1" to "spider_44"
        for i in 1...44 {
            let texture = SKTexture(imageNamed: "spider_\(i)")
            texture.filteringMode = .nearest // Ensures crisp animation
            frames.append(texture)
        }

        // Create the animation sequence
        let animation = SKAction.animate(with: frames, timePerFrame: 0.05)

        return animation
    }
}
