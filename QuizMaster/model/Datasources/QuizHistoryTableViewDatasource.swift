//
// Created by Kung Peter on 2017-05-06.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class QuizHistoryTableViewDatasource: NSObject, UITableViewDataSource {

    var quizMatches = [QuizMatch]()
    let currentQuizzer = ParseDbManager.shared.currentQuizzer()!

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizMatches.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quizMatch = quizMatches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizHistoryTableViewCell") as! QuizHistoryTableViewCell
        cell.categoryLabel.text = quizMatch.category

        if currentQuizzerIsChallenger(quizMatch: quizMatch) {
            cell.opponentNameLabel.text = quizMatch.challenged?.username
        } else {
            cell.opponentNameLabel.text = quizMatch.challenger?.username
        }

        if currentQuizzerIsWinner(quizMatch: quizMatch) {
            cell.winOrLooseImageView.image = UIImage(named: "winner")
        } else {
            cell.winOrLooseImageView.image = UIImage(named: "looser")
        }
        return cell
    }
}

//MARK: PrivateMethods

extension QuizHistoryTableViewDatasource {

    fileprivate func currentQuizzerIsChallenger(quizMatch: QuizMatch) -> Bool {
        return quizMatch.challenger?.objectId == currentQuizzer.objectId
    }

    fileprivate func currentQuizzerIsWinner(quizMatch: QuizMatch) -> Bool {

        if let challengerScore = quizMatch.challengerCorrectAnswers, let challegedScore = quizMatch.challengedCorrectAnswers {
            let winner: Quizzer?
            winner = (challengerScore.int8Value > challegedScore.int8Value) ? quizMatch.challenger : quizMatch.challenged
            return winner?.objectId == currentQuizzer.objectId

        }
        return false
    }
}
