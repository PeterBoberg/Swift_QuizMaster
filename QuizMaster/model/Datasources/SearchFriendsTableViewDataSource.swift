//
// Created by Kung Peter on 2017-04-26.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class SearchFriendsTableViewDataSource: NSObject, UITableViewDataSource {

    var searchResult: [Quizzer] = [Quizzer]()


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quizzerToShow = searchResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchFriendsCell") as! SearchFriendsCell
        cell.nameLabel.text = quizzerToShow.username
        ParseDbManager.shared.bgDownloadAvatarPictureFor(quizzer: quizzerToShow, completion: {
            (image, error) in
            guard error == nil else {
                print(error)
                return
            }

            if let image = image {
                cell.avatarImage.image = image
            }
        })

        let currentQuizzer = ParseDbManager.shared.currentQuizzer()!
        if ParseDbManager.shared.alreadyFriends(firstQuizzer: currentQuizzer, secondQuizzer: quizzerToShow) {
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor.gray
        } else {
            cell.isUserInteractionEnabled = true
            cell.backgroundColor = UIColor(red: 70 / 255, green: 68 / 255, blue: 115 / 255, alpha: 1.0)
        }
        return cell
    }

}
