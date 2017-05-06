//
// Created by Kung Peter on 2017-05-05.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class TableViewHeaderLabel: UILabel {


    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor(red: 12/255, green: 54/255, blue: 80/255, alpha: 0.6)
    }

}
