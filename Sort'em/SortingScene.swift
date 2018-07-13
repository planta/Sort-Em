//
//  SortingScene.swift
//  Sort'em
//
//  Created by Mario Plantosar on 14/03/15.
//  Copyright (c) 2015 Plantaapps. All rights reserved.
//

import SpriteKit
import GameKit

enum GameState:Int {
    case menu
    case playing
    case gameOver
}

struct animationTextures {
    static var animationTextureAtlas = [SKTextureAtlas]()
    static var firstFrame = [SKTexture]()
    static var animationFrames = [[SKTexture]]()
}

var state: GameState!

class SortingScene: SKScene, GKGameCenterControllerDelegate {
    var topBar: SKSpriteNode!
    var logo: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var currentScoreIcon: SKSpriteNode!
    var currentScoreLabel: SKLabelNode!
    var currentScoreResult: SKLabelNode!
    var bestScoreIcon: SKSpriteNode!
    var bestScoreLabel: SKLabelNode!
    var bestScoreResult: SKLabelNode!
    var highscoreIcon: SKSpriteNode!
    var highscoreLabel: SKLabelNode!
    var soundIcon: SKSpriteNode!
    var soundLabel: SKLabelNode!
    var timerLine: SKSpriteNode!
    var playAgainButton: SKSpriteNode!
    var playAgainLabel: SKLabelNode!
    var playIcon: SKSpriteNode!
    var leftArrow: SKSpriteNode!
    var rightArrow: SKSpriteNode!
    var bottomArrow: SKSpriteNode!
    var goodGuysNode: SKNode!
    var badGuysNode: SKNode!
    var goodGuysLabel1: SKLabelNode!
    var goodGuysLabel2: SKLabelNode!
    var badGuysLabel1: SKLabelNode!
    var badGuysLabel2: SKLabelNode!
    var animalsLabel: SKLabelNode!
    var gameOverNode: SKNode!
    var gameOverLabel1: SKLabelNode!
    var gameOverLabel2: SKLabelNode!
    var swiper: SKSpriteNode!
    var swipeable = Bool()
    var swiped = Bool()
    var requiredSwipeDirection = 0
    
    var randomSwiperNumber: Int!
    var previousSwiperNumber = -1
    
    var reactionTime = 2.7
    var frameSpeed = 0.05
    
    var playGoodSound = SKAction.playSoundFileNamed("good-sound.mp3", waitForCompletion: false)
    var playBadSound = SKAction.playSoundFileNamed("bad-sound.mp3", waitForCompletion: false)
    let wrongSwipeDelay = SKAction.wait(forDuration: 0.6)
    
    var score = 0
    let defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        swipeable = false
        swiped = false
        
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 230/255.0, green: 80/255.0, blue: 138/255.0, alpha: 1.0)
        
        //top bar
        topBar = SKSpriteNode(color: SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0), size: CGSize(width: self.frame.size.width, height: 50))
        topBar.anchorPoint = CGPoint(x: 0, y: 0)
        
        logo = SKSpriteNode(imageNamed: "logo")
        logo.anchorPoint = CGPoint(x: 0, y: 0)
        logo.size = CGSize(width: 90, height: 18)
        
        scoreLabel = SKLabelNode(fontNamed: "square-deal")
        scoreLabel.fontSize = 24
        scoreLabel.text = "0"
        
        //timer
        timerLine = SKSpriteNode(color: SKColor(red: 249/255.0, green: 147/255.0, blue: 187/255.5, alpha: 1.0), size: CGSize(width: self.frame.size.width, height: 4))
        timerLine.anchorPoint = CGPoint(x: 0, y: 0)
        timerLine.position = CGPoint(x: -(self.frame.size.width), y: self.frame.size.height-50)
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                topBar.position = CGPoint(x: 0, y: self.frame.size.height - 80)
                topBar.size = CGSize(width: self.frame.size.width, height: 80)
                logo.position = CGPoint(x: 16, y: self.frame.size.height - 65)
                scoreLabel.position = CGPoint(x: self.frame.size.width - 18, y: self.frame.size.height - 65)
            } else {
                topBar.position = CGPoint(x: 0, y: self.frame.size.height-50)
                logo.position = CGPoint(x: 16, y: self.frame.size.height-35)
                scoreLabel.position = CGPoint(x: self.frame.size.width - 18, y: self.frame.size.height-35)
            }
        } else {
            topBar.position = CGPoint(x: 0, y: self.frame.size.height-50)
            logo.position = CGPoint(x: 16, y: self.frame.size.height-35)
            scoreLabel.position = CGPoint(x: self.frame.size.width - 18, y: self.frame.size.height-35)
        }
        
        //play again button
        playAgainButton = SKSpriteNode(color: SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0), size: CGSize(width: 200, height: 60))
        playAgainLabel = SKLabelNode(fontNamed: "square-deal")
        playAgainLabel.fontSize = 30
        playAgainLabel.text = "play again"
        playAgainLabel.position = CGPoint(x: playAgainLabel.position.x + 30, y: playAgainLabel.position.y - 8)
        playIcon = SKSpriteNode(imageNamed: "play")
        playIcon.size = CGSize(width: 24, height: 32)
        playIcon.position = CGPoint(x: playIcon.position.x - 64, y: playIcon.position.y)
        playAgainButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 80)
        playAgainButton.addChild(playIcon)
        playAgainButton.addChild(playAgainLabel)
        
        //strelice
        leftArrow = SKSpriteNode(imageNamed: "strelica")
        leftArrow.size = CGSize(width: 30, height: 20)
        leftArrow.position = CGPoint(x: 54, y: self.frame.midY)
        leftArrow.zRotation = CGFloat(Double.pi);
        
        rightArrow = SKSpriteNode(imageNamed: "strelica")
        rightArrow.size = CGSize(width: 30, height: 20)
        rightArrow.position = CGPoint(x: self.frame.size.width - 54, y: self.frame.midY)
        
        bottomArrow = SKSpriteNode(imageNamed: "strelica")
        bottomArrow.size = CGSize(width: 30, height: 20)
        bottomArrow.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 120)
        bottomArrow.zRotation = CGFloat(Double.pi+(Double.pi/2))
        
        //tutorial labels
        goodGuysNode = SKNode()
        goodGuysLabel1 = SKLabelNode(fontNamed: "square-deal")
        goodGuysLabel1.fontSize = 22
        goodGuysLabel1.text = "good"
        goodGuysLabel2 = SKLabelNode(fontNamed: "square-deal")
        goodGuysLabel2.fontSize = 22
        goodGuysLabel2.position = CGPoint(x: goodGuysLabel1.position.x, y: goodGuysLabel1.position.y - 14)
        goodGuysLabel2.text = "guys"
        goodGuysNode.addChild(goodGuysLabel1)
        goodGuysNode.addChild(goodGuysLabel2)
        goodGuysNode.position = CGPoint(x: 100, y: self.frame.midY)
        
        badGuysNode = SKNode()
        badGuysLabel1 = SKLabelNode(fontNamed: "square-deal")
        badGuysLabel1.fontSize = 22
        badGuysLabel1.text = "bad"
        badGuysLabel2 = SKLabelNode(fontNamed: "square-deal")
        badGuysLabel2.fontSize = 22
        badGuysLabel2.position = CGPoint(x: badGuysLabel1.position.x, y: badGuysLabel1.position.y - 14)
        badGuysLabel2.text = "guys"
        badGuysNode.addChild(badGuysLabel1)
        badGuysNode.addChild(badGuysLabel2)
        badGuysNode.position = CGPoint(x: self.frame.size.width - 100, y: self.frame.midY)
        
        animalsLabel = SKLabelNode(fontNamed: "square-deal")
        animalsLabel.fontSize = 22
        animalsLabel.text = "animals"
        animalsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        
        //game over label
        gameOverNode = SKNode()
        gameOverLabel1 = SKLabelNode(fontNamed: "square-deal")
        gameOverLabel1.fontSize = 88
        gameOverLabel1.text = "game"
        gameOverLabel2 = SKLabelNode(fontNamed: "square-deal")
        gameOverLabel2.fontSize = 88
        gameOverLabel2.position = CGPoint(x: gameOverLabel1.position.x, y: gameOverLabel1.position.y - 60)
        gameOverLabel2.text = "over"
        gameOverNode.addChild(gameOverLabel1)
        gameOverNode.addChild(gameOverLabel2)
        gameOverNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 120)
        
        //scores
        currentScoreIcon = SKSpriteNode(imageNamed: "star-score.png")
        currentScoreIcon.size = CGSize(width: 18, height: 18)
        currentScoreIcon.position = CGPoint(x: self.frame.midX - 80, y: self.frame.midY + 20)
        currentScoreLabel = SKLabelNode(fontNamed: "square-deal")
        currentScoreLabel.fontSize = 24
        currentScoreLabel.fontColor = SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0)
        currentScoreLabel.text = "score"
        currentScoreLabel.position = CGPoint(x: self.frame.midX-40, y: self.frame.midY + 12)
        currentScoreResult = SKLabelNode(fontNamed: "square-deal")
        currentScoreResult.fontSize = 24
        currentScoreResult.fontColor = SKColor.white
        currentScoreResult.position = CGPoint(x: self.frame.midX + 14, y: self.frame.midY + 12)
        
        bestScoreIcon = SKSpriteNode(imageNamed: "best-score.png")
        bestScoreIcon.size = CGSize(width: 18, height: 18)
        bestScoreIcon.position = CGPoint(x: self.frame.midX - 80, y: self.frame.midY - 20)
        bestScoreLabel = SKLabelNode(fontNamed: "square-deal")
        bestScoreLabel.fontSize = 24
        bestScoreLabel.fontColor = SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0)
        bestScoreLabel.text = "best"
        bestScoreLabel.position = CGPoint(x: self.frame.midX - 44, y: self.frame.midY - 28)
        bestScoreResult = SKLabelNode(fontNamed: "square-deal")
        bestScoreResult.fontSize = 24
        bestScoreResult.fontColor = SKColor.white
        bestScoreResult.position = CGPoint(x: self.frame.midX + 14, y: self.frame.midY - 28)
        
        //highscore button
        highscoreIcon = SKSpriteNode(imageNamed: "high-score")
        highscoreIcon.size = CGSize(width: 16, height: 16)
        highscoreIcon.position = CGPoint(x: self.frame.midX - 90, y: self.frame.midY - 142)
        highscoreLabel = SKLabelNode(fontNamed: "square-deal")
        highscoreLabel.fontSize = 18
        highscoreLabel.fontColor = SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0)
        highscoreLabel.text = "high score"
        highscoreLabel.position = CGPoint(x: self.frame.midX - 40, y: self.frame.midY - 150)
        
        //sound button
        soundIcon = SKSpriteNode(imageNamed: "speaker")
        soundIcon.size = CGSize(width: 16, height: 16)
        soundIcon.position = CGPoint(x: self.frame.midX + 20, y: self.frame.midY - 142)
        soundLabel = SKLabelNode(fontNamed: "square-deal")
        soundLabel.fontSize = 18
        soundLabel.fontColor = SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0)
        soundLabel.position = CGPoint(x: self.frame.midX + 68, y: self.frame.midY - 150)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SortingScene.respondToSwipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SortingScene.respondToSwipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(SortingScene.respondToSwipe(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        self.addChild(topBar)
        self.addChild(logo)
        self.addChild(scoreLabel)
        self.switchToPlaying()
    }
    
    @objc func respondToSwipe(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if(state == GameState.playing && swipeable) {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.left:
                    self.swiped = true
                    self.removeAction(forKey: "MoveTimer")
                    self.removeAction(forKey: "Spawn")
                    self.timerLine.removeFromParent()
                    
                    if self.requiredSwipeDirection == 0 {
                        self.run(playGoodSound)
                        
                        moveSwiperLeft()
                        score += 1
                        
                        scoreLabel.text = score.description
                        
                        let delay = SKAction.wait(forDuration: 0.3)
                        let spawnSwiper = SKAction.run({
                            self.startSpawningSwipers()
                        })
                        
                        let spawnSequence = SKAction.sequence([delay, spawnSwiper])
                        self.run(spawnSequence)
                    } else {
                        self.run(playBadSound)
                        
                        moveSwiperLeft()
                        
                        let gameOver = SKAction.run({
                            self.switchToGameOver()
                        })
                        
                        let gameOverSequence = SKAction.sequence([wrongSwipeDelay, gameOver])
                        
                        self.run(gameOverSequence)
                    }
                    break
                case UISwipeGestureRecognizerDirection.right:
                    self.swiped = true
                    self.removeAction(forKey: "MoveTimer")
                    self.removeAction(forKey: "Spawn")
                    self.timerLine.removeFromParent()
                    
                    if self.requiredSwipeDirection == 1 {
                        self.run(playGoodSound)
                        
                        moveSwiperRight()
                        score += 1
                        
                        scoreLabel.text = score.description
                        
                        let delay = SKAction.wait(forDuration: 0.3)
                        let spawnSwiper = SKAction.run({
                            self.startSpawningSwipers()
                        })
                        
                        let spawnSequence = SKAction.sequence([delay, spawnSwiper])
                        self.run(spawnSequence)
                    } else {
                        self.run(playBadSound)
                        
                        moveSwiperRight()
                        
                        let gameOver = SKAction.run({
                            self.switchToGameOver()
                        })
                        
                        let gameOverSequence = SKAction.sequence([wrongSwipeDelay, gameOver])
                        
                        self.run(gameOverSequence)
                    }
                    break
                case UISwipeGestureRecognizerDirection.down:
                    self.swiped = true
                    self.removeAction(forKey: "MoveTimer")
                    self.removeAction(forKey: "Spawn")
                    self.timerLine.removeFromParent()
                    
                    if self.requiredSwipeDirection == 2 {
                        self.run(playGoodSound)
                        
                        moveSwiperDown()
                        score += 1
                        
                        scoreLabel.text = score.description
                        
                        let delay = SKAction.wait(forDuration: 0.3)
                        let spawnSwiper = SKAction.run({
                            self.startSpawningSwipers()
                        })
                        
                        let spawnSequence = SKAction.sequence([delay, spawnSwiper])
                        self.run(spawnSequence)
                    } else {
                        self.run(playBadSound)
                        
                        moveSwiperDown()
                        
                        let gameOver = SKAction.run({
                            self.switchToGameOver()
                        })
                        
                        let gameOverSequence = SKAction.sequence([wrongSwipeDelay, gameOver])
                        
                        self.run(gameOverSequence)
                    }
                    break
                default:
                    break
                }
                
                if self.swiped {
                    if score == 10 {
                        reactionTime -= 0.1
                        frameSpeed -= 0.01
                    } else if score == 20 {
                        reactionTime -= 0.05
                        frameSpeed -= 0.005
                    } else if score == 30 {
                        reactionTime -= 0.05
                        frameSpeed -= 0.005
                    } else if score == 40 {
                        reactionTime -= 0.03
                        frameSpeed -= 0.003
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let touchLocation = touch.location(in: self)
            
            if state == GameState.gameOver {
                if playAgainButton.contains(touchLocation) {
                    self.switchToNewGame()
                } else if highscoreIcon.contains(touchLocation) || highscoreLabel.contains(touchLocation) {
                    self.showLeaderboard()
                } else if soundIcon.contains(touchLocation) || soundLabel.contains(touchLocation) {
                    if backgroundMusicPlayer.isPlaying {
                        backgroundMusicPlayer.pause()
                        self.soundLabel.text = "sound on"
                    } else {
                        backgroundMusicPlayer.play()
                        self.soundLabel.text = "sound off"
                    }
                }
            }
        }
    }
    
    func switchToPlaying() {
        state = GameState.playing
        let tutorialDelay = SKAction.wait(forDuration: 2.0)
        let startGameDelay = SKAction.wait(forDuration: 3.0)
        
        //Hide ads when playing
        NotificationCenter.default.post(name: Notification.Name(rawValue: "hideAds"), object: nil)
        
        let showTutorial = SKAction.run({
            let moveArrowLeft = SKAction.moveTo(x: -60, duration: 0.6)
            let moveArrowRight = SKAction.moveTo(x: self.frame.size.width + 60, duration: 0.6)
            let moveArrowDown = SKAction.moveTo(y: -60, duration: 0.6)
            let moveLeft = SKAction.moveTo(x: -40, duration: 0.45)
            let moveRight = SKAction.moveTo(x: self.frame.size.width+40, duration: 0.45)
            let moveDown = SKAction.moveTo(y: -30, duration: 0.45)
            
            let shakeLeft = SKAction.moveBy(x: -30, y: 0, duration: 0.4)
            let shakeRight = SKAction.moveBy(x: 30, y: 0, duration: 0.4)
            let shakeDown = SKAction.moveBy(x: 0, y: -30, duration: 0.4)
            let shakeUp = SKAction.moveBy(x: 0, y: 30, duration: 0.4)
            
            let moveLeftSequence = SKAction.sequence([tutorialDelay, moveLeft])
            let moveRightSequence = SKAction.sequence([tutorialDelay, moveRight])
            let moveDownSequence = SKAction.sequence([tutorialDelay, moveDown])
            let shakeLeftArrowSequence = SKAction.sequence([shakeLeft, shakeRight, shakeLeft, shakeRight, moveArrowLeft])
            let shakeRightArrowSequence = SKAction.sequence([shakeRight, shakeLeft, shakeRight, shakeLeft, moveArrowRight])
            let shakeBottomArrowSequence = SKAction.sequence([shakeDown, shakeUp, shakeDown, shakeUp, moveArrowDown])
            
            self.goodGuysNode.run(moveLeftSequence)
            self.badGuysNode.run(moveRightSequence)
            self.animalsLabel.run(moveDownSequence)
            self.leftArrow.run(shakeLeftArrowSequence)
            self.rightArrow.run(shakeRightArrowSequence)
            self.bottomArrow.run(shakeBottomArrowSequence)
            
            self.addChild(self.leftArrow)
            self.addChild(self.rightArrow)
            self.addChild(self.bottomArrow)
            self.addChild(self.goodGuysNode)
            self.addChild(self.badGuysNode)
            self.addChild(self.animalsLabel)
        })
        
        let startSpawning = SKAction.run({
            self.startSpawningSwipers()
        })
        
        let startGameSequence = SKAction.sequence([showTutorial, startGameDelay, startSpawning])
        self.run(startGameSequence)
    }
    
    func switchToGameOver() {
        state = GameState.gameOver
        
        self.swiper.removeFromParent()
        
        //Show ads
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showAds"), object: nil)
        
        //Check for new highscore
        if score > self.bestScore() {
            self.newHighScore(score)
        }
                
        currentScoreResult.text = score.description
        bestScoreResult.text = self.bestScore().description
        
        self.stopSpawningSwipers()
        
        if backgroundMusicPlayer.isPlaying {
            soundLabel.text = "sound off"
        } else {
            soundLabel.text = "sound on"
        }
        
        self.addChild(gameOverNode)
        self.addChild(currentScoreIcon)
        self.addChild(currentScoreLabel)
        self.addChild(currentScoreResult)
        self.addChild(bestScoreIcon)
        self.addChild(bestScoreLabel)
        self.addChild(bestScoreResult)
        self.addChild(playAgainButton)
        self.addChild(highscoreIcon)
        self.addChild(highscoreLabel)
        self.addChild(soundIcon)
        self.addChild(soundLabel)
    }
    
    func switchToNewGame() {
        let gameTransition = SKTransition.fade(with: SKColor.black, duration: 0.2)
        let sortingScene = SortingScene(size: self.size)
        sortingScene.scaleMode = .aspectFill;
        self.view?.presentScene(sortingScene, transition: gameTransition)
    }
    
    func startSpawningSwipers() {
        SKAction.wait(forDuration: reactionTime)
        
        let spawn = SKAction.run({
            self.swipeable = true
            self.swiped = false
            
            let swiper = self.spawnSwiper()
            
            self.addChild(swiper)
        })
        
        self.run(spawn, withKey: "Spawn")
    }
    
    func spawnSwiper() -> SKNode {
        self.timerLine.removeFromParent()
        
        let moveTimerLine = SKAction.moveTo(x: 0, duration: 40 * frameSpeed)
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                self.timerLine.position = CGPoint(x: -(self.frame.size.width), y: self.frame.size.height-84)
            } else {
                self.timerLine.position = CGPoint(x: -(self.frame.size.width), y: self.frame.size.height-54)
            }
        } else {
            self.timerLine.position = CGPoint(x: -(self.frame.size.width), y: self.frame.size.height-54)
        }
        
        randomSwiperNumber = getRandomNumber()
        previousSwiperNumber = randomSwiperNumber
        
        self.swiper = SKSpriteNode()
        
        let animation = SKAction.animate(with: animationTextures.animationFrames[randomSwiperNumber], timePerFrame: frameSpeed)
        
        let remove = SKAction.run({
            self.swiper.removeFromParent()
            
            self.swipeable = false
            
            if !self.swiped {
                self.switchToGameOver()
            }
        })
        
        swiper = SKSpriteNode(texture: animationTextures.firstFrame[randomSwiperNumber])
        
        if randomSwiperNumber < 10 {
            self.requiredSwipeDirection = 0
        } else if randomSwiperNumber >= 10 && randomSwiperNumber < 20 {
            self.requiredSwipeDirection = 1
        } else {
            self.requiredSwipeDirection = 2
        }
        
        swiper.name = "Swiper"
        swiper.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        swiper.size = CGSize(width: 200, height: 200)
        
        let spawnSequence = SKAction.sequence([animation, remove])
        
        swiper.run(spawnSequence, withKey: "Spawn")
        timerLine.run(moveTimerLine, withKey: "MoveTimer")
        
        self.addChild(timerLine)
        
        return swiper
    }
    
    func getRandomNumber() -> Int {
        var randomNumber = Int(arc4random_uniform(27))
        
        if previousSwiperNumber == randomNumber {
            randomNumber = getRandomNumber()
        }
        
        return randomNumber
    }
    
    func moveSwiperLeft() {
        let move = SKAction.moveTo(x: -100, duration: 0.2)
        
        let remove = SKAction.run({
            self.swiper.removeFromParent()
            
            self.swipeable = false
            
            if(!self.swiped) {
                self.switchToGameOver()
            }
        })
        
        let moveSequence = SKAction.sequence([move,remove])
        
        self.swiper.run(moveSequence)
    }
    
    func moveSwiperRight() {
        let move = SKAction.moveTo(x: self.frame.size.width + 100, duration: 0.2)
        
        let remove = SKAction.run({
            self.swiper.removeFromParent()
            
            self.swipeable = false
            
            if(!self.swiped) {
                self.switchToGameOver()
            }
        })
        
        let moveSequence = SKAction.sequence([move,remove])
        
        self.swiper.run(moveSequence)
    }
    
    func moveSwiperDown() {
        let move = SKAction.moveTo(y: -self.swiper.size.height/2, duration: 0.2)
        
        let remove = SKAction.run({
            self.swiper.removeFromParent()
            
            self.swipeable = false
            
            if(!self.swiped) {
                self.switchToGameOver()
            }
        })
        
        let moveSequence = SKAction.sequence([move,remove])
        
        self.swiper.run(moveSequence)
    }
    
    func stopSpawningSwipers() {
        self.removeAction(forKey: "Spawn")
    }
    
//    func updateScore() {
//        score++
//        scoreLabel.text = String(score)
//    }
    
    func bestScore() -> Int {
        return defaults.integer(forKey: "Highscore")
    }
    
    func newHighScore(_ newHighScore: Int) {
        defaults.set(newHighScore, forKey: "Highscore")
        defaults.synchronize()
        
        saveHighscoreToGameCenter(newHighScore)
    }
    
    func saveHighscoreToGameCenter(_ score:Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "Sortem_leaderboard")
            
            scoreReporter.value = Int64(score)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                if error != nil {
                    print("error")
                }
            } as? (Error?) -> Void)
        }
    }
    
    //show leaderboard
    func showLeaderboard() {
        let viewController = self.view?.window?.rootViewController
        let gameCenter = GKGameCenterViewController()
        gameCenter.gameCenterDelegate = self
        viewController?.present(gameCenter, animated: true, completion: nil)
    }
    
    //hide leaderboard
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
