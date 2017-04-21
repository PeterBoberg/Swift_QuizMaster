//
// Created by Kung Peter on 2017-04-20.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hiScoreLabel: UILabel!


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
//        self.avatarImage.layer.cornerRadius = CGFloat(self.avatarImage.bounds.height / 2)
    }



}
