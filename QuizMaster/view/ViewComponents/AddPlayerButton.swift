//
// Created by Kung Peter on 2017-04-20.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class AddPlayerButton: UIButton {


    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }

    private func config() {
        self.backgroundColor = UIColor(red: 100 / 255, green: 100 / 255, blue: 100 / 255, alpha: 0.5)
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 7
        self.clipsToBounds = false
    }


}
