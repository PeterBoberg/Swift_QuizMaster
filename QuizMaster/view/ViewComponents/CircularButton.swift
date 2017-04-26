//
// Created by Kung Peter on 2017-04-26.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CircularButton: UIButton {

    @IBInspectable var iBColor: UIColor = UIColor.orange {
        didSet {
            self.backgroundColor = iBColor
            render()
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        render()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        render()
    }


    private func render() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.bounds.width / 2
        layoutIfNeeded()
    }

}
