//
//  candles.swift
//  Game
//
//  Created by Shakira Al-Jahmee on 2/18/25.
//

import SpriteKit

class Candle: SKSpriteNode {
    
    var candleAnimation: SKAction!

    init(position: CGPoint) {
        let texture = SKTexture(imageNamed: "candle_1") //first frame as placeholder
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = "candle"

        // Scale the candle (adjust size if needed)
        self.setScale(1.5)

        // Set the candle's position
        self.position = CGPoint(x: 3, y: 3)

        //load animation frames
        candleAnimation = createCandleAnimation()
        
        // Start the animation loop
        self.run(SKAction.repeatForever(candleAnimation))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCandleAnimation() -> SKAction {
        var frames: [SKTexture] = []

        // Load frames named "candle_1" to "candle_7"
        for i in 1...7 {
            let texture = SKTexture(imageNamed: "candle_\(i)")
            texture.filteringMode = .nearest // Ensures a crisp animation
            frames.append(texture)
        }

        // Create the animation sequence
        let animation = SKAction.animate(with: frames, timePerFrame: 0.1)

        return animation
    }
}
