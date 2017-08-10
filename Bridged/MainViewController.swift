//
//  MainViewController.swift
//  Bridged
//
//  Created by Preston Jordan on 5/30/16.
//  Copyright © 2016 Preston Jordan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = self.prefersStatusBarHidden
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    @IBAction func playButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "goToMenuViewController", sender: self)
    }

    @IBAction func highScoreButtonPressed(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "goToHighScoreViewController", sender: self)
    }
   
}
