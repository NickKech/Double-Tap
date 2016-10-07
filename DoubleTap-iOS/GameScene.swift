//
//  GameScene.swift
//  DoubleTap
//
//  Created by Nikolaos Kechagias on 19/08/15.
//  Copyright (c) 2015 Nikolaos Kechagias. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    /* 1 */
    let soundMessage = SKAction.playSoundFileNamed("Message.m4a", waitForCompletion: false)
    let soundMatchFailed = SKAction.playSoundFileNamed("MatchCardFailed.m4a", waitForCompletion: false)
    let soundMatchDone = SKAction.playSoundFileNamed("MatchCardSuccessed.m4a", waitForCompletion: false)
    let soundLevelDone = SKAction.playSoundFileNamed("LevelCompleted.m4a", waitForCompletion: false)
    let soundSelect = SKAction.playSoundFileNamed("SelectCard.m4a", waitForCompletion: false)
    
    /* 3  Holds the number of cards. */
    let totalCards = 17
    
    /* 1  Holds the number of rows of the game board. */
    let numRows = 5
    /* 2 Holds the number of columns of the game board.*/
    let numColumns = 4
    
    /* 4  2-Dimensional array of cards. */
    //var cardsArray = [[CardNode]]()
    
    /* 5  Holds the first selected card. */
    var firstSelectedCard: CardNode? = nil
    
    // Holds the second selected card.
    var secondSelectedCard: CardNode? = nil

    /* Enable or disable touches */
    var enableTouches = true
    /* 8 */
    var isGameOver = false
    
    /* 2 */
    var scoreLabel = LabelNode(fontNamed: "Gill Sans Bold Italic")
    var timeLabel = LabelNode(fontNamed: "Gill Sans Bold Italic")
    
    /* 3 */
    var score: Int = 0 {
        didSet {
            /* 4 */
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    /* 1 */
    var timedt = 0.0
    
    /* 3 */
    var time: Int = 60 {
        didSet {
            /* 4 */
            timeLabel.text = "Time: \(time)"
        }
    }

    override func didMove(to view: SKView) {
        /* Add Background */
        addBackground()
        
        /* Create Game Board */
        createGameBoard(selectRandomCards())
        
        /* Add HUD */
        addHUD()
    }
    
    func addHUD() {
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = zOrderValue.hud.rawValue
        scoreLabel.position = CGPoint(x: size.width * 0.25, y: size.height - scoreLabel.fontSize)
        scoreLabel.text = "Score: \(score)"
        addChild(scoreLabel)
        
        timeLabel.fontSize = 40
        timeLabel.fontColor = SKColor.white
        timeLabel.zPosition = zOrderValue.hud.rawValue
        timeLabel.position = CGPoint(x: size.width * 0.75, y: size.height - timeLabel.fontSize)
        timeLabel.text = "Time: \(time)"
        addChild(timeLabel)
    }

    // MARK: - Game States
    
    func showMessage(_ imageNamed: String) {
        /* 1 */
        let panel = SKSpriteNode(texture: SKTexture(imageNamed: "\(imageNamed).png"))
        panel.zPosition = zOrderValue.message.rawValue
        panel.position = CGPoint(x: size.width / 2, y: -size.height)
        panel.name = imageNamed
        addChild(panel)
        
        /* 2 */
        let move = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height / 2), duration: 0.50)
        panel.run(SKAction.sequence([soundMessage, move]))
    }

    
    func createGameBoard(_ filenames: [String]) {
        let backTexture = SKTexture(imageNamed: "back.png")
        
        var index = 0
        for row in 0 ..< numRows {
            for column in 0 ..< numColumns {
                /* 1 */
                
                let card = CardNode(texture: backTexture, row: row,  column: column, filename: filenames[index])
                card.zPosition = zOrderValue.card.rawValue
                card.name = "Card"
                card.zPosition = 1
                card.position = calculateCardsPosition(row, column: column, cardSize: card.size)
                /* 2 */
                addChild(card)
                
                index += 1
            }
        }
    }

    func calculateCardsPosition(_ row: Int, column: Int, cardSize: CGSize) -> CGPoint {
        let marginX = (size.width - cardSize.width * CGFloat(numColumns)) / 2
        let marginY = (size.height - cardSize.height * CGFloat(numRows)) / 2
        
        let x = marginX + cardSize.width / 2 + cardSize.width * CGFloat(column)
        let y = marginY + cardSize.height / 2 + cardSize.height * CGFloat(row)
        
        return CGPoint(x: x, y: y)
    }
    
    func selectRandomCards() -> [String] {
        /* 1 */
        var allCards =  [String]()
        for index in 0 ... totalCards {
            allCards.append("card_\(index).png")
        }
        
        /* 2 */
        var selectedCards = [String]()
        
        let numberOfCardsInBoard = numRows * numColumns / 2
        for _ in 0 ..< numberOfCardsInBoard {
            
            /* 3 */
            let num = random(0, max: UInt32(allCards.count))
            let filename = allCards[num]
            
            /* 4 */
            allCards.remove(at: num)
            
            /* 5 */
            selectedCards.append(filename)
            selectedCards.append(filename)
        }
        
        /* 6 */
        for _ in 0 ..< selectedCards.count {
            let num1 = random(0, max: UInt32(selectedCards.count))
            let num2 = random(0, max: UInt32(selectedCards.count))
            
            let temp = selectedCards[num1]
            selectedCards[num1] = selectedCards[num2]
            selectedCards[num2] = temp
        }
        
        /* 7 */
        return selectedCards
    }

    // MARK: - Library
    func random(_ min: UInt32, max: UInt32) -> Int {
        return Int(arc4random_uniform(max - min) + min)
    }

    
    // MARK: - User Interface
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "Background.png")
        background.name = "Background"
        background.zPosition = zOrderValue.background.rawValue
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
    }
    
    func newGame() {
        removeAllChildren()
        addBackground()
        firstSelectedCard = nil
        secondSelectedCard = nil
        enableTouches = true
        isGameOver = false
        createGameBoard(selectRandomCards())
        addHUD()
        score = 0
        time  = 60
        timedt = 0
    }

    func nextLevel() {
        removeAllChildren()
        addBackground()
        firstSelectedCard = nil
        secondSelectedCard = nil
        enableTouches = true
        isGameOver = false
        createGameBoard(selectRandomCards())
        addHUD()
        time  = 60
        timedt = 0
    }
    
    func checkIfLevelCompleted() {
        /* 1 */
        if !isGameOver {
            if let _ = childNode(withName: "Card") {
                /* 2 */
                return
            } else {
                /* 3 */
                isGameOver = true
                showMessage("LevelCompleted")
            }
        }
    }

    func updateScore() {
        score += 10
    }
    
    func checkForMatch() {
        /* 1 */
        if let card1 = firstSelectedCard, let card2 = secondSelectedCard {
            if card1.filename == card2.filename {
                /* 2 */
                run(soundMatchDone)
                /* 3 */
                let block = SKAction.run({
                    card1.remove()
                    card2.remove()
                    self.firstSelectedCard = nil
                    self.secondSelectedCard = nil
                    self.enableTouches = true
                })
                
                let delay = SKAction.wait(forDuration: 1.0)
                let sequence = SKAction.sequence([block, delay])
                    
                    run(sequence, completion: {
                        /* Checks if level completed */
                        self.checkIfLevelCompleted()

                    })
                /* Update score */
                updateScore()
            } else {
                /* 5 */
                run(soundMatchFailed)
                self.firstSelectedCard = nil
                 self.secondSelectedCard = nil
                /* 6 */
                card1.flip() { }
                card2.flip() {
                    /* 7 */
                    self.enableTouches = true
                }
            }
        }
    }


    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        /* 1 */
        if isGameOver {
            return
        }
        
        /* 2 */
        if timedt + 1 < currentTime {
            timedt = currentTime;
            time -= 1
            
            /* 3 */
            if time <= 0 {
                showMessage("GameOver")
                isGameOver = true
            }
        }

    }
    
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let location = touches.first?.location(in: self)
        /* New Game */
        let gameOver = childNode(withName: "GameOver")
        if gameOver != nil {
            newGame()
            return
        }
        
        /* Level Completed */
        let levelCompleted = childNode(withName: "LevelCompleted")
        if levelCompleted != nil {
            nextLevel()
            return
        }
        
        /* 1 */
        if isGameOver || !enableTouches {
            return
        }
        
        let node = atPoint(location!)
        if node.name == "Card" {
            /* 4 */
            run(soundSelect)
            let card = node as! CardNode
            if !card.isFaceUp {
                if firstSelectedCard == nil {
                    enableTouches = false
                    card.flip() {
                        self.firstSelectedCard = card
                        self.enableTouches = true
                    }
                } else {
                    enableTouches = false
                    card.flip() {
                        self.secondSelectedCard = card
                        /* 7 */
                        self.checkForMatch()
                    }
                }
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    
}
