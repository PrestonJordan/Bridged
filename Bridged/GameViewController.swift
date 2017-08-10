//
//  GameViewController.swift
//  Experiment
//
//  Created by Preston Jordan on 3/16/16.
//  Copyright (c) 2016 Preston Jordan. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let skView = self.view as! SKView? {
        
            if skView.scene == nil {
                if let scene = GameScene(fileNamed: "GameScene") {
                    scene.viewController = self
                    scene.scaleMode = .aspectFill
                    scene.size = skView.bounds.size
                    skView.presentScene(scene)
                }

                skView.ignoresSiblingOrder = true
                skView.showsNodeCount = true
                skView.showsFPS = true
                
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        _ = self.view as! SKView
            let scene = GameScene(fileNamed: "GameScene")!
            scene.viewController = self
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
