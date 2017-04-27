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


    deinit {
        print("OnlineFriendsCollectionViewCell destryoed")
    }
}
