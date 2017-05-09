//
// Created by Kung Peter on 2017-05-06.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class QuizHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var winOrLooseImageView: UIImageView!

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var opponentNameLabel: UILabel!
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.contentView.backgroundColor = UIColor(red: 12 / 255, green: 54 / 255, blue: 80 / 255, alpha: 0.6)
    }

}
