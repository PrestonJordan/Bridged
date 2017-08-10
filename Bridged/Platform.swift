//
//  Platform.swift
//  Experiment
//
//  Created by Preston Jordan on 3/23/16.
//  Copyright © 2016 Preston Jordan. All rights reserved.
//

import UIKit
import SpriteKit

class Platform: SKSpriteNode {
    var isInFirstPosition: Bool = false
    init() {
         super.init(texture: nil, color: SKColor.black, size: CGSize(width: 50, height: 260))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

