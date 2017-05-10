//
// Created by Kung Peter on 2017-05-09.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


@IBDesignable
class ProgressLoaderView: UIView {

    var circlePathLayer = CAShapeLayer()
    var circleRadius = CGFloat(40)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = self.bounds
        circlePathLayer.path = arcPath().cgPath
    }

    func startAnimation() {

        circlePathLayer.add(strokeEndAnimation(), forKey: "strokeEnd")
    }

    func stopAnimation() {

        circlePathLayer.removeAnimation(forKey: "strokeEnd")
    }

    private func configure() {

        circlePathLayer.frame = self.bounds
        circlePathLayer.lineWidth = 10
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = UIColor(red: 0/255, green: 102/255, blue: 204/255, alpha: 1.0).cgColor
        circlePathLayer.add(strokeEndAnimation(), forKey: "strokeEnd")
        self.layer.addSublayer(circlePathLayer)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }

    func arcPath() -> UIBezierPath {
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = startAngle + CGFloat(M_PI * 2)
        return UIBezierPath(arcCenter: CGPoint(x: arcFrame().midX, y: arcFrame().midY), radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }

    private func arcFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleFrame.origin.x = circlePathLayer.bounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathLayer.bounds.midY - circleFrame.midY
        return circleFrame
    }

    private func strokeEndAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        animation.repeatCount = MAXFLOAT
        return animation
    }

    deinit {
        print("ProgressLoaderView destroyed")
    }

}
