//
// Created by Kung Peter on 2017-04-30.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class RequestsTableViewDatasource: NSObject, UITableViewDataSource {

    var challenges = [QuizChallange]()

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTableViewCell") as! RequestTableViewCell
        let challenge = challenges[indexPath.row]
        cell.categoryLabel.text = challenge.category

        if challenge.challenger!.username == ParseDbManager.shared.currentQuizzer()!.username {
            cell.challengerLabel.text = challenge.challenged?.username
            cell.contentView.backgroundColor = UIColor.lightGray
            cell.isUserInteractionEnabled = false
        } else {
            cell.challengerLabel.text = challenge.challenger?.username
            cell.contentView.backgroundColor = UIColor(red: 22 / 255, green: 58 / 255, blue: 110 / 255, alpha: 1.0)
            cell.isUserInteractionEnabled = true
        }
        return cell
    }

}
