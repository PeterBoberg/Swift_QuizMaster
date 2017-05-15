//
// Created by Kung Peter on 2017-05-05.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class GradientBackgroundView: UIView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let middleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        let bottomColor = UIColor.clear.cgColor
        gradientLayer.colors = [topColor, middleColor, bottomColor]
        gradientLayer.locations = [0.0, 0.7, 1.0]
        gradientLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: 2 * self.frame.height / 3)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }


}
