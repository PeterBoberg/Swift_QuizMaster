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
    @IBOutlet weak var acceptableImageView: UIImageView!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.contentView.backgroundColor = UIColor(red: 12/255, green: 54/255, blue: 80/255, alpha: 0.6)
    }

    func setAcceptable(_ acceptable: Bool) {
        switch acceptable {
        case false:
            self.acceptableImageView.image = UIImage(named: "requestPending")
            self.isUserInteractionEnabled = false
            break
        case true:
            self.acceptableImageView.image = UIImage(named: "requestAccept")
            self.isUserInteractionEnabled = true
            break
        }
    }

    deinit {
        print("RequestTableViewCell destroyed")
    }

}
