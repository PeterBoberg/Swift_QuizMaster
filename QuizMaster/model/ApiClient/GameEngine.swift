//
// Created by Kung Peter on 2017-05-01.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation

class GameEngine {


    static let shared = GameEngine()

    private init() {
    }

    func createNewGame(category: String,
                       challenger: Quizzer,
                       challenged: Quizzer,
                       completion: @escaping (Bool, Error?) -> Void) {

        ParseDbManager.shared.getAllQuestionsFor(category: category, completion: {
            [unowned self] (questions, error) in

            guard error == nil else {
                completion(false, error)
                return
            }

            if let questions = questions {
                let chosenQuestions = self.getRandomizedQuestions(maxCount: 10, allQuestions: questions)

                ParseDbManager.shared.createNewQuizMatch(challenger: challenger,
                        challenged: challenged,
                        questions: chosenQuestions,
                        category: category,
                        completion: completion)


            } else {
                completion(false, NSError())
                print("questions Was nil")
            }
        })
    }

    private func getRandomizedQuestions(maxCount: Int, allQuestions: [PQuizQuestion]) -> [PQuizQuestion] {
        var usedIndexes = [Int]()
        var chosenQuestions = [PQuizQuestion]()
        var currentRound = 0
        while currentRound < maxCount && currentRound < allQuestions.count {

            var randomIndex: Int
            repeat {
                randomIndex = Int(arc4random_uniform(UInt32(allQuestions.count)))
            } while usedIndexes.contains(Int(randomIndex))

            chosenQuestions.append(allQuestions[randomIndex])
            usedIndexes.append(randomIndex)
            currentRound += 1
        }

        return chosenQuestions
    }
}
