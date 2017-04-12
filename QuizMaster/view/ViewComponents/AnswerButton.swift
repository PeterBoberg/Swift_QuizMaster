//
// Created by Kung Peter on 2017-04-09.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class AnswerButton: UIButton {

    var isCorrectButton = false

    public func makeRounded() {

        self.layer.borderColor = UIColor.yellow.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

}
