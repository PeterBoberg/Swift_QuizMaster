//
//  OnlineFriendsCollectionViewCell.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-26.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class OnlineFriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatarImage: AvatarImageView!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 7
        self.backgroundColor = UIColor(red: 0.0, green: 0.4, blue: 0.6, alpha: 0.8)
    }

    deinit {
        print("OnlineFriendsCollectionViewCell destryoed")
    }
}
