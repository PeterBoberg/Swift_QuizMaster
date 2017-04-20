//
// Created by Kung Peter on 2017-04-20.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class UserCollectionViewDatasource: NSObject, UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        cell.nameLabel.text = "Peter Boberg"
        cell.hiScoreLabel.text = "10"
        cell.avatarImage.image = UIImage(named: "defaultUser")
        return cell
    }

}
