//
// Created by Kung Peter on 2017-04-20.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class UserCollectionViewDatasource: NSObject, UICollectionViewDataSource {

    var quizPlayers: [QuizPlayer]?


    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizPlayers?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        guard let quizPlayers = quizPlayers else {
            return UICollectionViewCell()
        }
        let quizPlayer = quizPlayers[indexPath.row]
        cell.nameLabel.text = quizPlayer.name

        if let pictureData = quizPlayer.avatar {
            cell.avatarImage.image = UIImage(data: pictureData as Data)
        }

        let hiScore = findBestQuizResult(quizResults: quizPlayer.quizGameResult)
        if let hiScore = hiScore {
            cell.hiScoreLabel.text = String(hiScore.correctAnswers)
        } else {
            cell.hiScoreLabel.text = "N/A"
        }

        return cell
    }

}

// MARK: privateMethods

extension UserCollectionViewDatasource {

    fileprivate func findBestQuizResult(quizResults: NSSet?) -> QuizGameResult? {
        guard let quizResults = quizResults else {
            return nil
        }
        if quizResults.count > 0 {
            var bestResult = quizResults.anyObject() as! QuizGameResult
            for case let result as QuizGameResult in quizResults {
                if result > bestResult {
                    bestResult = result
                }

            }
            return bestResult
        }
        return nil
    }
}
