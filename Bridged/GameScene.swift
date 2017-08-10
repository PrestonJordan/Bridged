//
//  GameScene.swift
//  Created by Preston Jordan on 3/16/16.
//  Copyright (c) 2016 Preston Jordan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var viewController: UIViewController?
    let prefs = UserDefaults.standard
    
    let classicGameMode = GameOptions.classic.rawValue
    let feelGameMode = GameOptions.feel.rawValue
    let dropGameMode = GameOptions.drop.rawValue
    let thinnerGameMode = GameOptions.thinner.rawValue
    
    let leftPlatformUpRightXPosition: CGFloat = 50
    var universalPlatformHeight: CGFloat!
    
    let avatarOffset: CGFloat = 20
    var screenWidth: CGFloat!
    
    let platformBonusWidth = 15
    
    var isAvatarMoving = false
    
    let background = SKSpriteNode()
    
    let bridgeWidth: CGFloat = 2.5
    var bridgeHeight: CGFloat = 0
    
    var gameMode = String()
    
    var score = 0
    
    var isTouching: Bool = false
    var isFalling: Bool = false
    
    var location: CGPoint!
    
    let bridge = SKSpriteNode()
    let avatar = SKSpriteNode()
    
    let platformOne = Platform()
    let platformTwo = Platform()
    
    let platformBonus = SKSpriteNode()
    
    let scoreLabel = SKLabelNode()
    
    var spriteArray = Array<SKTexture>()
    var backgroundArray = ["Background_Desert", "Background_Grass", "Background_Mountain", "Background_Snow"]
    var platformImageArray = ["Platform_Desert", "Platform_Grass", "Platform_Mountain", "Platform_Snow"]
    var characterArray = ["Character_Desert_Blink", "Character_Desert", "Character_Grass_Blink", "Character_Grass", "Character_Mountain_Blink", "Character_Mountain", "Character_Snow_Blink", "Character_Snow"]

    var randomNum = Int(arc4random_uniform(4))
    
    override func didMove(to view: SKView) {
        switch randomNum {
        case 0:
            spriteArray.append(SKTexture.init(imageNamed: characterArray[0]))
            spriteArray.append(SKTexture.init(imageNamed: characterArray[1]))
        case 1:
            spriteArray.append(SKTexture.init(imageNamed: characterArray[2]))
            spriteArray.append(SKTexture.init(imageNamed: characterArray[3]))
        case 2:
            spriteArray.append(SKTexture.init(imageNamed: characterArray[4]))
            spriteArray.append(SKTexture.init(imageNamed: characterArray[5]))
        case 3:
            spriteArray.append(SKTexture.init(imageNamed: characterArray[6]))
            spriteArray.append(SKTexture.init(imageNamed: characterArray[7]))
        default:
            break
        }
        
        
        gameMode = prefs.string(forKey: "userGameMode")!
        
        screenWidth = self.view?.frame.width
        universalPlatformHeight = (self.view?.frame.height)! / 2 - 50
        if((self.view?.frame.height)! - universalPlatformHeight < self.view!.frame.width - leftPlatformUpRightXPosition) {
            universalPlatformHeight = (self.view?.frame.height)! - (self.view!.frame.width - leftPlatformUpRightXPosition)
        }
        
        backgroundColor = SKColor.black
        background.texture = SKTexture.init(imageNamed: backgroundArray[randomNum])
        background.anchorPoint = CGPoint.zero
        background.zPosition = 0
        background.size = self.frame.size
        self.addChild(background)
        
        avatar.zPosition = 1
        avatar.size = CGSize(width: 25, height: 25)
        avatar.texture = spriteArray[1]
        avatar.position = CGPoint(x: leftPlatformUpRightXPosition - avatarOffset, y: universalPlatformHeight + 12.5)
        self.addChild(avatar)
        
        let blink = SKAction.animate(with: self.spriteArray, timePerFrame: 0.25)
        let wait = SKAction.wait(forDuration: 4.5, withRange: 1.5)
        let mainCharacterAnimation = SKAction.sequence([blink, wait, blink, blink, wait, blink, blink])
        let repeatAction = SKAction.repeatForever(mainCharacterAnimation)
        avatar.run(repeatAction);
        
        platformOne.texture = SKTexture.init(imageNamed: platformImageArray[randomNum])
        platformOne.zPosition = 2
        platformOne.size = CGSize(width: getRandomWidth(), height: universalPlatformHeight)
        platformOne.isInFirstPosition = true
        platformOne.position = CGPoint(x: 50 - platformOne.size.width / 2, y: universalPlatformHeight - platformOne.size.height / 2)
        self.addChild(platformOne)
        
        platformTwo.texture = SKTexture.init(imageNamed: platformImageArray[randomNum])
        platformTwo.zPosition = 2
        platformTwo.color = SKColor.blue
        
        platformTwo.isInFirstPosition = false
        if(gameMode != thinnerGameMode) {
            platformTwo.size = CGSize(width: getRandomWidth(), height: universalPlatformHeight)
            platformTwo.position = CGPoint(x: getRandomPosition(platformTwo.frame.size.width), y: universalPlatformHeight - platformTwo.size.height / 2)
        } else {
            platformTwo.size = CGSize(width: self.frame.size.width / 2, height: universalPlatformHeight)
            platformTwo.position = CGPoint(x: self.frame.width / 2 + platformTwo.size.width / 2, y: universalPlatformHeight - platformTwo.size.height / 2)
        }
        self.addChild(platformTwo)
        
        platformBonus.color = SKColor.red
        platformBonus.zPosition = 1
        platformBonus.size = CGSize(width: platformBonusWidth, height: 5)
        platformBonus.position.y = platformTwo.position.y - platformBonus.size.height / 2
        platformTwo.addChild(platformBonus)
        
        scoreLabel.zPosition = 2
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 45
        scoreLabel.position = CGPoint(x:self.frame.midX, y:self.frame.maxY - 50)
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isUserInteractionEnabled = false
        isTouching = true
        
        location = CGPoint(x: leftPlatformUpRightXPosition - bridgeWidth / 2, y: universalPlatformHeight - bridgeWidth + 2)
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        isFalling = true
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        updateBridgeGrow()
        updateBridgeFall()
    }
    
    func updateBridgeGrow() {
        
        if(isTouching) {
            
            bridge.removeFromParent()
            bridge.zPosition = 3
            
            if(gameMode == classicGameMode || gameMode == thinnerGameMode) {
                bridge.color = SKColor.white
                bridge.size = CGSize(width: bridgeWidth, height: bridgeHeight)
                bridge.position = CGPoint(x: location.x, y: location.y + (bridgeHeight / 2))
            } else if(gameMode == feelGameMode) {
                bridge.color = SKColor.clear
                bridge.size = CGSize(width: bridgeWidth, height: bridgeHeight)
                bridge.position = CGPoint(x: location.x, y: location.y + (bridgeHeight / 2))
            } else if(gameMode == dropGameMode) {
                bridge.color = SKColor.white
                bridge.size = CGSize(width: bridgeHeight, height: bridgeWidth)
                bridge.position = CGPoint(x: location.x + (bridgeHeight / 2) + (bridgeWidth / 2), y: location.y + 200)
            }
            
            self.addChild(bridge)
            
            bridgeHeight += 4
        }
    }
    
    func updateBridgeFall() {
        if(isFalling) {
            bridgeHeight -= 4
            
            bridge.removeFromParent()
            
            if(gameMode != dropGameMode) {
                bridge.color = SKColor.white
                bridge.position = CGPoint(x: location.x + bridgeWidth / 2, y: location.y)
                bridge.anchorPoint = CGPoint(x: 1, y: 0)
                
                let action = SKAction.rotate(byAngle: CGFloat(-M_PI / 2), duration: 0.5)
                bridge.run(action)
            } else {
                let action = SKAction.moveTo(y: location.y + bridgeWidth / 2, duration: 0.5)
                bridge.run(action)
                
            }
            
            self.addChild(bridge)
            isFalling = false
            let wait = SKAction.wait(forDuration: 0.55)
            let run = SKAction.run {
                self.isAvatarMoving = true
                self.updateAvatarAndCheckGameStatus()
            }
            self.run(SKAction.sequence([wait, run]))
        }
    }
    
    
    func updateAvatarAndCheckGameStatus() {
        
        var platformArray: [Platform] = []
        if(platformOne.isInFirstPosition) {
            platformArray.append(platformOne)
            platformArray.append(platformTwo)
        } else {
            platformArray.append(platformTwo)
            platformArray.append(platformOne)
        }
        
        // Checks to see if the bridge landed on the second platform, if so, the user can continue playing current game, otherwise, the game is over
        if(leftPlatformUpRightXPosition + bridgeHeight < platformArray[1].position.x - platformArray[1].size.width / 2 || leftPlatformUpRightXPosition + bridgeHeight > platformArray[1].position.x + platformArray[1].size.width / 2){
            
            let moveAvatarAcrossBridge = SKAction.moveTo(x: avatar.position.x + bridgeHeight + avatarOffset, duration: 1)
            avatar.run(moveAvatarAcrossBridge)
            
            let wait = SKAction.wait(forDuration: 1)
            let run = SKAction.run {
                self.gameOver()
            }
            self.run(SKAction.sequence(([wait, run])))
            
            
        } else {
            
            // User can continue playing current game
            updateScore()
            
            // User receives extra point for landing on the platform bonus
            if(leftPlatformUpRightXPosition + bridgeHeight >= platformArray[1].position.x - platformBonus.size.width / 2 && leftPlatformUpRightXPosition + bridgeHeight <= platformArray[1].position.x    + platformBonus.size.width / 2) {
                
                updateScore()
            }
            
            let moveAvatarAcrossBridge = SKAction.moveTo(x: platformArray[1].position.x + platformArray[1].size.width / 2 - avatarOffset, duration: 1)
            avatar.run(moveAvatarAcrossBridge)
            
            let wait = SKAction.wait(forDuration: 1)
            let run = SKAction.run {
                self.isAvatarMoving = false
                self.updateGame()
            }
            self.run(SKAction.sequence(([wait, run])))
        }
    }
    
    
    func updateScore() {
        score += 1
        scoreLabel.text = "\(score)"
        let rise = SKAction.moveBy(x: 0, y: 10, duration: 0.5)
        let fall = SKAction.moveBy(x: 0, y: -10, duration: 0.5)
        let jump = SKAction.sequence([rise, fall])
        scoreLabel.run(jump)
        
    }
    
    func updateGame() {
        
        var platformArray: [Platform] = []
        if(platformOne.isInFirstPosition) {
            platformArray.append(platformOne)
            platformArray.append(platformTwo)
        } else {
            platformArray.append(platformTwo)
            platformArray.append(platformOne)
        }
        
        // Move left platform off screen
        let moveLeftPlatformOffScreen = SKAction.moveTo(x: 0 - platformArray[0].size.width / 2, duration: 0.01)
        platformArray[0].run(moveLeftPlatformOffScreen)
        
        // Move right platform to left position
        let moveRightPlatformToLeftPosition = SKAction.moveTo(x: leftPlatformUpRightXPosition - platformArray[1].size.width / 2, duration: 0.2)
        platformArray[1].run(moveRightPlatformToLeftPosition)
        
        // Move avatar with right platform to left position
        let moveAvatarToLeft = SKAction.moveTo(x: leftPlatformUpRightXPosition - avatarOffset, duration: 0.2)
        avatar.run(moveAvatarToLeft)
        
        bridge.removeFromParent()
        platformBonus.removeFromParent()
        
        var wait = SKAction.wait(forDuration: 0.3)
        var run = SKAction.run {
            
            
            if(self.gameMode != self.thinnerGameMode) {
                let movePlatform2YPosition = SKAction.moveTo(y: self.universalPlatformHeight - platformArray[0].size.height / 2, duration: 0.001)
                platformArray[0].run(movePlatform2YPosition)
                
                platformArray[0].addChild(self.platformBonus)
                
                let platformWidth: CGFloat = self.getRandomWidth()
                let platformPosition: CGFloat = self.getRandomPosition(platformWidth)
                
                platformArray[0].size = CGSize(width: platformWidth, height: self.universalPlatformHeight)
                
                platformArray[0].position = CGPoint(x: self.frame.size.width + (platformArray[0].size.width / 2), y: self.universalPlatformHeight)
                
                // Move right platform onto screen
                let moveRightPlatform2View = SKAction.moveTo(x: platformPosition, duration: 0.4)
                platformArray[0].run(moveRightPlatform2View)
            } else {
                

                platformArray[0].size = CGSize(width: platformArray[1].size.width - 10, height: self.universalPlatformHeight)
                if(platformArray[0].size.width < 7.5) {
                    platformArray[1].size.width = self.frame.width / 2
                    platformArray[0].size.width = self.frame.width / 2
                    platformArray[0].position.x = self.leftPlatformUpRightXPosition - platformArray[1].size.width / 2
                    
                }
                
                if(platformArray[0].size.width <= 15) {
                    self.platformBonus.size.width = platformArray[0].size.width
                }
                
                let movePlatform2YPosition = SKAction.moveTo(y: self.universalPlatformHeight - platformArray[0].size.height / 2, duration: 0.001)
                platformArray[0].run(movePlatform2YPosition)
                
                platformArray[0].addChild(self.platformBonus)
                
                platformArray[0].position = CGPoint(x: self.frame.size.width + (platformArray[0].size.width / 2), y: self.universalPlatformHeight)
                
                // Move right platform onto screen
                let moveRightPlatform2Screen = SKAction.moveTo(x: self.frame.width / 2 + platformArray[0].size.width / 2, duration: 0.4)
                platformArray[0].run(moveRightPlatform2Screen)
                
            }
            
        }
        
        self.run(SKAction.sequence([wait, run]))
        
        platformArray[0].isInFirstPosition = false
        platformArray[1].isInFirstPosition = true
        
        wait = SKAction.wait(forDuration: 0.75)
        run = SKAction.run {
            self.resetSceneAfterSuccessfulLand()
        }
        
        self.run(SKAction.sequence([wait, run]))
        
    }
    
    func getRandomWidth() -> CGFloat {
        
        return CGFloat(arc4random_uniform(80)) + 20
        
    }
    
    func getRandomPosition(_ width: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(screenWidth - width - 70))) + 50 + width / 2 + 10
    }
    
    
    func resetSceneAfterSuccessfulLand() {
        bridgeHeight = 0
        
        if(gameMode != dropGameMode) {
            let action = SKAction.rotate(byAngle: CGFloat(M_PI / 2), duration: 0.001)
            bridge.run(action)
        }
        
        bridge.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.isUserInteractionEnabled = true
    }
    
    func resetSceneAfterLoss() {
        bridgeHeight = 0
        
        // Resets bridge position
        if(gameMode == classicGameMode || gameMode == feelGameMode || gameMode == thinnerGameMode) {
            let rotateBridge = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0.001)
            bridge.run(rotateBridge)
            bridge.size = CGSize(width: bridgeWidth, height: bridgeHeight)
            bridge.position = CGPoint(x: location.x, y: location.y)
        } else if(gameMode == dropGameMode) {
            let rotateBridge = SKAction.rotate(byAngle: CGFloat(M_PI / 2), duration: 0.001)
            bridge.run(rotateBridge)
            bridge.size = CGSize(width: bridgeHeight, height: bridgeWidth)
            bridge.position = CGPoint(x: location.x + (bridgeHeight / 2) + (bridgeWidth / 2), y: location.y + 200)
        }
        
        bridge.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Resets platform positions
        var platformArray: [Platform] = []
        if(platformOne.isInFirstPosition) {
            platformArray.append(platformOne)
            platformArray.append(platformTwo)
        } else {
            platformArray.append(platformTwo)
            platformArray.append(platformOne)
        }
        
        if(gameMode == thinnerGameMode) {
                platformArray[0].size = CGSize(width: getRandomWidth(), height: universalPlatformHeight)
                platformArray[0].position = CGPoint(x: 50 - platformArray[0].size.width / 2, y: universalPlatformHeight - platformArray[0].size.height / 2)
                
                platformArray[1].size = CGSize(width: self.frame.size.width / 2, height: universalPlatformHeight)
                platformArray[1].position = CGPoint(x: self.frame.width / 2 + platformArray[1].size.width / 2, y: universalPlatformHeight - platformArray[1].size.height / 2)
                
                platformBonus.size = CGSize(width: platformBonusWidth, height: 5)
                platformBonus.position.y = platformTwo.position.y - platformBonus.size.height / 2
        } else {
        
            platformArray[1].size = CGSize(width: getRandomWidth(), height: universalPlatformHeight)
            platformArray[1].position = CGPoint(x: getRandomPosition(platformArray[0].frame.size.width), y: universalPlatformHeight - platformArray[0].size.height / 2)
        }
        
        // Resets avatar position
        self.avatar.position = CGPoint(x: self.leftPlatformUpRightXPosition - self.avatarOffset, y: self.universalPlatformHeight + 12.5)
        
        score = 0
        scoreLabel.text = "0"

        self.isUserInteractionEnabled = true
    }
    
    
    
    func gameOver() {
        isAvatarMoving = false
        
        prefs.set(score, forKey: "currentScore")
        
        if(gameMode == dropGameMode) {
            bridge.position = CGPoint(x: location.x + bridgeWidth / 2, y: location.y)
            bridge.anchorPoint = CGPoint(x: 0, y: 0)
        }
        
        let dropAvatar = SKAction.moveTo(y: avatar.position.y - universalPlatformHeight, duration: 0.25)
        let dropBridge = SKAction.rotate(byAngle: CGFloat(-M_PI_2), duration: 0.25)
        
        avatar.run(dropAvatar)
        bridge.run(dropBridge)
        
        let wait = SKAction.wait(forDuration: 0.35)
        let run = SKAction.run {
            self.resetSceneAfterLoss()
            self.viewController?.performSegue(withIdentifier: "goToGameOverViewController", sender: self)
        }
        
        self.run(SKAction.sequence([wait, run]))
        
    }
    
}
