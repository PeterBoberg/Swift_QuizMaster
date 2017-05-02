//
//  QuizMatchTableViewCell.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-02.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class QuizMatchTableViewCell: UITableViewCell {


    @IBOutlet weak var challengerLabel: UILabel!
    @IBOutlet weak var challengedLabel: UILabel!
    @IBOutlet weak var challgerScore: UILabel!
    @IBOutlet weak var challengedScore: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    func setStartable(_ startable: Bool) {

        switch startable {
        case false:
            self.contentView.backgroundColor = UIColor(red: 141/255, green: 0, blue: 0, alpha: 1.0)
            self.isUserInteractionEnabled = false
            break
        case true:
            self.contentView.backgroundColor = UIColor(red: 66/255, green: 141/255, blue: 50/255, alpha: 1.0)
            self.isUserInteractionEnabled = true
            break
        }
    }

}
