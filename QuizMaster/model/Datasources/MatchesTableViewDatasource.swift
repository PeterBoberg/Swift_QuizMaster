//
// Created by Kung Peter on 2017-05-02.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class MatchesTableViewDatasource: NSObject, UITableViewDataSource {

    var currentMatches = [QuizMatch]()
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMatches.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quizMatch = currentMatches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizMatchTableviewCell") as! QuizMatchTableViewCell

        cell.challengerLabel.text = quizMatch.challenger?.username
        cell.challengedLabel.text = quizMatch.challenged?.username
        cell.categoryLabel.text = quizMatch.category

        let challengerScore = quizMatch.challengerCorrectAnswers as! Int
        let challengedScore = quizMatch.challengedCorrectAnswers as! Int
        cell.challgerScore.text = (challengerScore > -1) ? String(challengedScore) : "Waiting"
        cell.challengedScore.text = (challengedScore > -1) ? String(challengedScore) : "Waiting"

        if quizMatch.turn!.username == ParseDbManager.shared.currentQuizzer()!.username {
            cell.setStartable(true)
        } else {
            cell.setStartable(false)
        }
        return cell
    }

}
