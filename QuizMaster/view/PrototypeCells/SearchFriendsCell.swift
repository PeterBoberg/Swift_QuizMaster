//
//  SearchFriendsCell.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-26.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit


class SearchFriendsCell: UITableViewCell {

    @IBOutlet weak var avatarImage: AvatarImageView!
    @IBOutlet weak var nameLabel: UILabel!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }

    deinit {
        print("SearchFriendsCell destroyed")
    }

}
