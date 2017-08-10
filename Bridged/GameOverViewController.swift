//
//  GameOverViewController.swift
//  Bridged
//
//  Created by Preston Jordan on 4/9/16.
//  Copyright © 2016 Preston Jordan. All rights reserved.
//

import UIKit
import iAd

class GameOverViewController: UIViewController, ADBannerViewDelegate {
    let prefs = UserDefaults.standard

    var gameMode = 0
    var highScore = 0
    var currentScore = 0
    
    var backgroundArray = ["Background_Desert_Blur", "Background_Grass_Blur", "Background_Mountain_Blur", "Background_Snow_Blur"]
    
    var randomNum = Int(arc4random_uniform(4))

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var changeModeButton: UIButton!
    @IBOutlet weak var modeNameLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        load()
        timer()
    }
    
    @IBAction func changeModeButtonPressed(_ sender: UIButton) {
        let viewsToPop = 2
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(viewsToPop)
        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    @IBAction func homeButtonPressed(_ sender: AnyObject) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = prefersStatusBarHidden
        
        currentScore = prefs.integer(forKey: "currentScore")
        gameMode = prefs.integer(forKey: "userGameMode")

        switch gameMode {
        case 0:
            modeNameLabel.text = "Classic"
            highScore = prefs.integer(forKey: "highScoreMode0")
            if(checkScore()) {
                prefs.set(currentScore, forKey: "highScoreMode0")
            }
            updateLabels()
            
        case 1:
            modeNameLabel.text = "Feeling"
            highScore = prefs.integer(forKey: "highScoreMode1")
            if(checkScore()) {
                prefs.set(currentScore, forKey: "highScoreMode1")
            }
            updateLabels()
        case 2:
            modeNameLabel.text = "Drop"
            highScore = prefs.integer(forKey: "highScoreMode2")
            if(checkScore()) {
                prefs.set(currentScore, forKey: "highScoreMode2")
            }
            updateLabels()
        case 3:
            modeNameLabel.text = "Thinner"
            highScore = prefs.integer(forKey: "highScoreMode3")
            if(checkScore()) {
                prefs.set(currentScore, forKey: "highScoreMode3")
            }
            updateLabels()
        default:
            print("error")

        }
        if(randomNum == 2 || randomNum == 3) {
            bestScoreLabel.textColor = UIColor.white
            currentScoreLabel.textColor = UIColor.white
            modeNameLabel.textColor = UIColor.white
            gameNameLabel.textColor = UIColor.white
        }
        activityIndicator.isHidden = true
        backgroundImage.image = UIImage(named: backgroundArray[randomNum])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() {
        if(checkScore()) {
            currentScoreLabel.text = "\(currentScore)"
            bestScoreLabel.text = "New Best!"
            switch randomNum {
            case 0:
                bestScoreLabel.backgroundColor = UIColor(netHex: 0x69C7ED)
            case 1:
                bestScoreLabel.backgroundColor = UIColor(netHex: 0x69C7ED)
            case 2:
                bestScoreLabel.backgroundColor = UIColor(netHex: 0x69C7ED)
            case 3:
                bestScoreLabel.backgroundColor = UIColor(netHex: 0x71c4b9)
            default:
                break
            }
            bestScoreLabel.clipsToBounds = true
            bestScoreLabel.layer.cornerRadius = bestScoreLabel.frame.size.height / 4
            
        } else {
            currentScoreLabel.text = "\(currentScore)"
            bestScoreLabel.text = "Best: \(highScore)"
            bestScoreLabel.backgroundColor = UIColor.clear
        }
    }
    
    func checkScore() -> Bool {
        if(currentScore > highScore) {
            return true
        } else {
            return false
        }
    }
    
    func load() {
        loadingLabel.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        gameNameLabel.isHidden = true
        restartButton.isHidden = true
        homeButton.isHidden = true
        changeModeButton.isHidden = true
        modeNameLabel.isHidden = true
        currentScoreLabel.isHidden = true
        bestScoreLabel.isHidden = true
    }
    
    func beginSegue() {
        activityIndicator.startAnimating()
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func timer () {
        _ = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(MenuViewController.beginSegue), userInfo: nil, repeats: false)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
