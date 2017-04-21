//
// Created by Kung Peter on 2017-04-21.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class AvatarImageView: UIImageView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor(red: 12/255, green: 39/255, blue: 25/255, alpha: 1.0).cgColor
        self.clipsToBounds = true
    }

}
