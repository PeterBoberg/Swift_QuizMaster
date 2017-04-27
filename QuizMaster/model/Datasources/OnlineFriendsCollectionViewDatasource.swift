//
// Created by Kung Peter on 2017-04-26.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class OnlineFriendsCollectionViewDatasource: NSObject, UICollectionViewDataSource {

    var friends = [Quizzer]()
    weak var muliplayerStartViewController: MultiplayerStartViewController?

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let friend = friends[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlineFriendsCollectionViewCell", for: indexPath) as! OnlineFriendsCollectionViewCell
        cell.nameLabel.text = friend.username
        ParseDbManager.shared.downloadAvatarPictureFor(quizzer: friend, completion: {
            (image, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let image = image {
                cell.avatarImage.image = image
            }

        })

        return cell
    }
}
