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
        let quizzer = searchResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchFriendsCell") as! SearchFriendsCell
        cell.nameLabel.text = quizzer.username
        if let imageFile = quizzer.avatarImage {
            imageFile.getDataInBackground(block: {
                (data, error) in
                if error == nil {
                    cell.avatarImage.image = UIImage(data: data!)
                }
            })
        }

        return cell
    }

}
