//
//  HighScoreViewController.swift
//  Bridged
//
//  Created by Preston Jordan on 5/30/16.
//  Copyright © 2016 Preston Jordan. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
     let prefs = UserDefaults.standard

    @IBOutlet weak var classicScoreLabel: UILabel!
    @IBOutlet weak var feelScoreLabel: UILabel!
    @IBOutlet weak var dropScoreLabel: UILabel!
    @IBOutlet weak var thinnerScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = prefersStatusBarHidden
        
        classicScoreLabel.text = String(prefs.integer(forKey: "highScoreMode0"))
        
        feelScoreLabel.text = String(prefs.integer(forKey: "highScoreMode1"))
        
        dropScoreLabel.text = String(prefs.integer(forKey: "highScoreMode2"))
        
        thinnerScoreLabel.text = String(prefs.integer(forKey: "highScoreMode3"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    @IBAction func homeButtonPressed(_ sender: AnyObject) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
