//
//  CardNode.swift
//  DoubleTap
//

import SpriteKit

/* 1 */
class CardNode: SKSpriteNode {
    /* 2 */
    let row: Int
    let column: Int
    
    /* 3 */
    let iconTexture: SKTexture
    /* 4 */
    let backTexture: SKTexture
    /* 5 */
    let filename: String
    /* 6 */
    var isFaceUp = false
    
    /* 7 */
    init(texture: SKTexture, row: Int, column: Int, filename: String) {
        self.row = row
        self.column = column
        self.filename = filename
        self.backTexture = texture
        self.iconTexture = SKTexture(imageNamed: filename)
        
        super.init(texture: texture, color: SKColor.whiteColor(), size: texture.size())
    }
    
    /* 8 */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip(completion:() -> ()) {
        /* 1 */
        let scaleDown = SKAction.scaleXTo(0, duration: 0.25)
        let scaleUp = SKAction.scaleXTo(1.0, duration: 0.25)
       
        /* 2 */
        let backTextureAction = SKAction.setTexture(self.backTexture)
        let iconTextureAction = SKAction.setTexture(self.iconTexture)
        
        /* 3 */
        if isFaceUp {
            runAction(SKAction.sequence([scaleDown, backTextureAction, scaleUp]))
        } else {
            runAction(SKAction.sequence([scaleDown, iconTextureAction, scaleUp]))
        }
        isFaceUp = !isFaceUp
        
        /* 4 */
        runAction(SKAction.waitForDuration(0.50), completion: completion)
    }
    
    func remove() {
        /* 1 */
        let scaleDown = SKAction.scaleTo(0, duration: 0.25)
        /* 2 */
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI) * 2, duration: 0.25)
        /* 3 */
        let remove = SKAction.removeFromParent()
        /* 4 */
        let group = SKAction.group([scaleDown, rotate])
        
        /* 5 */
        runAction(SKAction.sequence([group, remove]))
    }
    
}
