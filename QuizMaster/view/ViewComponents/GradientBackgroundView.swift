//
// Created by Kung Peter on 2017-05-05.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable
class GradientBackgroundView: UIView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    private func configure() {
        let gradientLayer = CAGradientLayer()
        let topColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let middleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        let bottomColor = UIColor.clear.cgColor
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: 2 * self.bounds.height / 3)
        gradientLayer.colors = [topColor, middleColor, bottomColor]
        gradientLayer.locations = [0.0, 0.7, 1.0]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}