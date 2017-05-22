//
// Created by Kung Peter on 2017-04-09.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

//MARK: extension UIView

extension UIView {

    public func setXOffset(withInt x: Int) {
        setXOffset(withFloat: CGFloat(x))
    }

    public func setXOffset(withFloat x: CGFloat) {
        self.frame.origin.x += x
    }

    public func setYOffset(withFloat y: CGFloat) {
        self.frame.origin.y += y
    }

    public func setYOffset(withInt y: Int) {
        setYOffset(withFloat: CGFloat(y))
    }

    public func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
}


// MARK: extension Array

extension Array {

    mutating func shuffleInPlace() {

        guard self.count > 2 else {
            return
        }

        for index in 0...self.count - 1 {
            let rand1 = Int(arc4random_uniform(UInt32(self.count)))
            let rand2 = Int(arc4random_uniform(UInt32(self.count)))
            let tempItem = self[rand1]
            self[rand1] = self[rand2]
            self[rand2] = tempItem
        }

    }
}

// MARK: extension String

extension String {
    func convertHtmlSymbols() throws -> String? {
        guard let data = data(using: .utf8) else {
            return nil
        }

        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
}

// MARK: extension ViewController

extension UIViewController {

    func getProgressIndicatorViewController() -> ProgressIndicatorViewController {
        let progressVc = self.storyboard?.instantiateViewController(withIdentifier: "ProgressIndicatorViewController") as! ProgressIndicatorViewController
        progressVc.modalPresentationStyle = .overCurrentContext
        progressVc.modalTransitionStyle = .crossDissolve
        return progressVc
    }
}