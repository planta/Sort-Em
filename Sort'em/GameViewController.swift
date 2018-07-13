//
//  GameViewController.swift
//  Sort'em
//
//  Created by Mario Plantosar on 14/03/15.
//  Copyright (c) 2015 Plantaapps. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameKit



var backgroundMusicPlayer: AVAudioPlayer!

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        var frameNumber = 0
        var firstFrameName: String!
        
        //var menuAtlasName = ["menu-top", "menu-bottom"]
        var atlasName = ["afro-nerd", "angel", "baby", "doc", "king", "monocle", "nerd", "policeman", "pop", "santa", "angryman", "bone", "devil", "fire", "frankenstein", "ghost", "pirate", "thief", "vampire", "zombie", "bear", "cat", "dog", "giraffe", "panda", "pig", "rabbit"]
        
        self.authenticateLocalPlayer()
        
        //load menu textures
//        menuAnimationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "MenuTop"), atIndex: 0)
//        menuAnimationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "MenuBottom"), atIndex: 1)
        
        //load good guy textures
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "AfroNerd"), at: 0)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Angel"), at: 1)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Baby"), at: 2)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Doc"), at: 3)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "King"), at: 4)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Monocle"), at: 5)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Nerd"), at: 6)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Policeman"), at: 7)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Pop"), at: 8)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Santa"), at: 9)
        
        //load bad guy textures
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Angryman"), at: 10)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Bone"), at: 11)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Devil"), at: 12)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Fire"), at: 13)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Frankenstein"), at: 14)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Ghost"), at: 15)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Pirate"), at: 16)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Thief"), at: 17)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Vampire"), at: 18)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Zombie"), at: 19)
        
        //load animal textures
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Bear"), at: 20)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Cat"), at: 21)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Dog"), at: 22)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Giraffe"), at: 23)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Panda"), at: 24)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Pig"), at: 25)
        animationTextures.animationTextureAtlas.insert(SKTextureAtlas(named: "Rabbit"), at: 26)
        
        //initialise menu animations
//        for i=0; i<menuAtlasName.count; i++ {
//            frameNumber = menuAnimationTextures.animationTextureAtlas[i].textureNames.count
//            firstFrameName = "\(menuAtlasName[i])1"
//            
//            menuAnimationTextures.animationFrames.append([menuAnimationTextures.animationTextureAtlas[i].textureNamed(firstFrameName)])
//            
//            for j=2; j<=frameNumber; j++ {
//                var frameName = "\(menuAtlasName[i])\(j)"
//                menuAnimationTextures.animationFrames[i].append(menuAnimationTextures.animationTextureAtlas[i].textureNamed(frameName))
//                
//                println(frameName)
//            }
//            
//            menuAnimationTextures.firstFrame.append(menuAnimationTextures.animationFrames[i][0])
//        }
        
        //initialise character animations
        for i in (0..<atlasName.count) {
//        for i=0; i<atlasName.count; i += 1 {
            frameNumber = animationTextures.animationTextureAtlas[i].textureNames.count
            firstFrameName = "\(atlasName[i])1"
            
            animationTextures.animationFrames.append([animationTextures.animationTextureAtlas[i].textureNamed(firstFrameName)])
            
            for j in (2...frameNumber/2) {
//            for j=2; j<=frameNumber/2; j += 1 {
                let frameName = "\(atlasName[i])\(j)"
                animationTextures.animationFrames[i].append(animationTextures.animationTextureAtlas[i].textureNamed(frameName))
            }
            
            animationTextures.firstFrame.append(animationTextures.animationFrames[i][0])
        }
        
        skView.presentScene(scene)
        
        playBackgroundMusic("music.aiff")
        
//        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.handleNotification(_:)), name: NSNotification.Name(rawValue: "hideAds"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.handleNotification(_:)), name: NSNotification.Name(rawValue: "showAds"), object: nil)
        
//        self.loadAds()
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            } else {
                print((GKLocalPlayer.localPlayer().isAuthenticated))
            }
        }
    }
    
//    func loadAds() {
//        adBannerView = ADBannerView(frame: CGRect.zeroRect)
//        //adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.frame.size.height - 7)
//        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.frame.size.height + adBannerView.frame.size.height / 2)
//        adBannerView.delegate = self
//        adBannerView.isHidden = true
//        view.addSubview(adBannerView)
//    }
//    
//    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
//        adLoaded = true
//        
//        if banner.isHidden {
//            if state != GameState.playing && state != GameState.menu {
//                self.showAds(banner)
//            }
//        }
//    }
//    
//    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
//        if !banner.isHidden {
//            self.hideAds(banner)
//        }
//    }
//    
//    func handleNotification(_ notification: Notification) {
//        if notification.name == "hideAds" {
//            self.hideAds(adBannerView)
//        } else if notification.name == "showAds" {
//            self.showAds(adBannerView)
//        }
//    }
//    
//    func showAds(_ banner: ADBannerView) {
//        if adLoaded {
//            UIView.beginAnimations("animateAdBannerOn", context: nil)
//            banner.frame = banner.frame.offsetBy(dx: 0, dy: -banner.frame.size.height)
//            UIView.commitAnimations()
//            banner.isHidden = false
//        }
//    }
//    
//    func hideAds(_ banner: ADBannerView) {
//        if adLoaded {
//            UIView.beginAnimations("animateAdBannerOff", context: nil)
//            banner.frame = banner.frame.offsetBy(dx: 0, dy: banner.frame.size.height)
//            UIView.commitAnimations()
//            banner.isHidden = true
//        }
//    }
    
    func playBackgroundMusic(_ filename: String) {
        let url = Bundle.main.url(
            forResource: filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        
        do {
            try backgroundMusicPlayer =
                AVAudioPlayer(contentsOf: url!)
        } catch {
            print(error)
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.volume = 0.3
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
