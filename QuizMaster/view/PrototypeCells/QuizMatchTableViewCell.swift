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
    @IBOutlet weak var acceptImageView: UIImageView!


    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.contentView.backgroundColor = UIColor(red: 12/255, green: 54/255, blue: 80/255, alpha: 0.6)
    }

    func setStartable(_ startable: Bool) {

        switch startable {
        case false:
            self.contentView.backgroundColor = UIColor(red: 202 / 255, green: 27 / 255, blue: 39 / 255, alpha: 0.4)
            self.isUserInteractionEnabled = false
            self.acceptImageView.image = UIImage(named: "quizmatchPending")
            break
        case true:
            self.contentView.backgroundColor = UIColor(red: 67 / 255, green: 202 / 255, blue: 85 / 255, alpha: 0.4)
            self.acceptImageView.image = UIImage(named: "quizmatchAccept")
            self.isUserInteractionEnabled = true
            break
        }
    }

    deinit {
        print("QuizMatchTableViewCell destroyed")
    }
}
