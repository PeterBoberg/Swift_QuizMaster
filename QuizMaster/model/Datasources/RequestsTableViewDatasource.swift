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
            cell.setAcceptable(false)
        } else {
            cell.challengerLabel.text = challenge.challenger?.username
            cell.setAcceptable(true)
        }
        return cell
    }

    deinit {
        print("RequestsTableViewDatasource destryed")
    }

}
