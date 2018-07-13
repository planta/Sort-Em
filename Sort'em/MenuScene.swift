//
//  GameScene.swift
//  Sort'em
//
//  Created by Mario Plantosar on 14/03/15.
//  Copyright (c) 2015 Plantaapps. All rights reserved.
//

import SpriteKit
import GameKit

//struct menuAnimationTextures {
//    static var animationTextureAtlas = [SKTextureAtlas]()
//    static var firstFrame = [SKTexture]()
//    static var animationFrames = [[SKTexture]]()
//}

class GameScene: SKScene, GKGameCenterControllerDelegate {
    //var topAnimation: SKSpriteNode!
    //var bottomAnimation: SKSpriteNode!
    var topImage: SKSpriteNode!
    var bottomImage: SKSpriteNode!
    var logo: SKSpriteNode!
    var playButton: SKSpriteNode!
    var playIcon: SKSpriteNode!
    var playLabel: SKLabelNode!
    var highscoreIcon: SKSpriteNode!
    var highscoreLabel: SKLabelNode!
    var soundIcon: SKSpriteNode!
    var soundLabel: SKLabelNode!
    var gameTransition: SKTransition!
    var sortingScene: SortingScene!
    
    override func didMove(to view: SKView) {
        state = GameState.menu
        
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 230/255.0, green: 80/255.0, blue: 138/255.0, alpha: 1.0)
        
        gameTransition = SKTransition.fade(with: SKColor.black, duration: 0.4)
        sortingScene = SortingScene(size: self.size)
        sortingScene.scaleMode = .aspectFill
        sortingScene.isUserInteractionEnabled = true
        
//        let topAnimationFrames = SKAction.animateWithTextures(menuAnimationTextures.animationFrames[0], timePerFrame: 0.05)
//        let repeatTopAnimation = SKAction.repeatActionForever(topAnimationFrames)
//        let bottomAnimationFrames = SKAction.animateWithTextures(menuAnimationTextures.animationFrames[1], timePerFrame: 0.05)
//        let repeatBottomAnimation = SKAction.repeatActionForever(bottomAnimationFrames)
        
        //top animation
//        topAnimation = SKSpriteNode(texture: menuAnimationTextures.firstFrame[0])
//        topAnimation.size = CGSizeMake(self.frame.size.width, 150)
//        topAnimation.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height - 75)
//        topAnimation.runAction(repeatTopAnimation)
        
        //bottom animation
//        bottomAnimation = SKSpriteNode(texture: menuAnimationTextures.firstFrame[1])
//        bottomAnimation.size = CGSizeMake(self.frame.size.width, 150)
//        bottomAnimation.position = CGPoint(x: CGRectGetMidX(self.frame), y: 75)
//        bottomAnimation.runAction(repeatBottomAnimation)
        
        //top image
        topImage = SKSpriteNode(imageNamed: "menu-top")
        topImage.size = CGSize(width: self.frame.size.width, height: 150)
        topImage.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 75)
        
        //bottom image
        bottomImage = SKSpriteNode(imageNamed: "menu-bottom")
        bottomImage.size = CGSize(width: self.frame.size.width, height: 150)
        bottomImage.position = CGPoint(x: self.frame.midX, y: 75)
        
        //logo
        logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: 200, height: 40)
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 70)
        
        //play button
        playButton = SKSpriteNode(color: SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0), size: CGSize(width: 200, height: 60))
        playIcon = SKSpriteNode(imageNamed: "play")
        playIcon.size = CGSize(width: 24, height: 32)
        playIcon.position = CGPoint(x: playIcon.position.x - 64, y: playIcon.position.y)
        playLabel = SKLabelNode(fontNamed: "square-deal")
        playLabel.text = "play game"
        playLabel.fontSize = 30;
        playLabel.position = CGPoint(x: playLabel.position.x + 30, y: playLabel.position.y - 8)
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        playButton.addChild(playIcon)
        playButton.addChild(playLabel)
        
        //highscore button
        highscoreIcon = SKSpriteNode(imageNamed: "high-score")
        highscoreIcon.size = CGSize(width: 16, height: 16)
        highscoreIcon.position = CGPoint(x: self.frame.midX - 90, y: self.frame.midY - 58)
        highscoreLabel = SKLabelNode(fontNamed: "square-deal")
        highscoreLabel.fontSize = 18
        highscoreLabel.fontColor = SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0)
        highscoreLabel.text = "high score"
        highscoreLabel.position = CGPoint(x: self.frame.midX - 40, y: self.frame.midY - 66)
        
        //sound button
        soundIcon = SKSpriteNode(imageNamed: "speaker")
        soundIcon.size = CGSize(width: 16, height: 16)
        soundIcon.position = CGPoint(x: self.frame.midX + 20, y: self.frame.midY - 58)
        soundLabel = SKLabelNode(fontNamed: "square-deal")
        soundLabel.fontSize = 18
        soundLabel.fontColor = SKColor(red: 205/255.0, green: 10/255.0, blue: 86/255.0, alpha: 1.0)
        soundLabel.text = "sound off"
        soundLabel.position = CGPoint(x: self.frame.midX + 68, y: self.frame.midY - 66)
        
        //self.addChild(topAnimation)
        self.addChild(topImage)
        self.addChild(logo)
        self.addChild(playButton)
        self.addChild(highscoreIcon)
        self.addChild(highscoreLabel)
        self.addChild(soundIcon)
        self.addChild(soundLabel)
        self.addChild(bottomImage)
        //self.addChild(bottomAnimation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let touchLocation = touch.location(in: self)
            
            if playButton.contains(touchLocation) {
                self.switchToGame()
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
    
    func switchToGame() {
        self.view?.presentScene(sortingScene, transition: gameTransition)
    }
    
    func showLeaderboard() {
        let viewController = self.view?.window?.rootViewController
        let gameCenter = GKGameCenterViewController()
        gameCenter.gameCenterDelegate = self
        viewController?.present(gameCenter, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
