//
//  RequestTableViewCell.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-28.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var challengerLabel: UILabel!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
    
    deinit {
        print("RequestTableViewCell destroyed")
    }

}
