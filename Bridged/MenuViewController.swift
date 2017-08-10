//
//  MenuViewController.swift
//  Experiment
//
//  Created by Preston Jordan on 3/27/16.
//  Copyright © 2016 Preston Jordan. All rights reserved.
//

import UIKit

enum GameOptions: String {
    case classic = "Classic"
    case feel = "Feel"
    case drop = "Drop"
    case thinner = "Thinner"
}

class MenuViewController: UIViewController {
    let prefs = UserDefaults.standard
    var gameMode = String()
    
    var backgroundName = "Background_Snow_Blur"
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var classicButton: UIButton!
    @IBOutlet weak var feelButton: UIButton!
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var thinnerButton: UIButton!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        _ = prefersStatusBarHidden
        backgroundImage.image = UIImage.init(named: backgroundName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        classicButton.isHidden = false
        feelButton.isHidden = false
        dropButton.isHidden = false
        thinnerButton.isHidden = false
        loadingLabel.isHidden = true
        activityIndicator.isHidden = true
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    @IBAction func gameModeClassicSelected(_ sender: UIButton) {
        load()
        gameMode = GameOptions.classic.rawValue
        timer()
    }
    
    @IBAction func gameModeFeelingSelected(_ sender: UIButton) {
        load()
        gameMode = GameOptions.feel.rawValue
        timer()
    }
    
    @IBAction func gameModeDropSelected(_ sender: UIButton) {
        load()
        gameMode = GameOptions.drop.rawValue
        timer()
    }
    
    @IBAction func gameModeThinnerSelected(_ sender: UIButton) {
        load()
        gameMode = GameOptions.thinner.rawValue
        timer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prefs.set(gameMode, forKey: "userGameMode")
    }
    
    func timer () {
        _ = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(MenuViewController.beginSegue), userInfo: nil, repeats: false)
    }
    
    func beginSegue() {
        activityIndicator.stopAnimating()
        self.performSegue(withIdentifier: "goToGameViewController", sender: self)
    }
    
    func load () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        classicButton.isHidden = true
        feelButton.isHidden = true
        dropButton.isHidden = true
        thinnerButton.isHidden = true
        loadingLabel.isHidden = false
    }
}
















