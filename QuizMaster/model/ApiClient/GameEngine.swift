//
// Created by Kung Peter on 2017-05-01.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation


//MARK: Public API

class GameEngine {


    static let shared = GameEngine()

    private init() {
    }

    func createNewQuizMatch(category: String,
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


    func handleQuizRoundFinished(quizMatch: QuizMatch?,
                                 correctAnswers: Int,
                                 appIsTerminating: Bool,
                                 completion: ((Bool, Error?) -> Void)?) {

        guard let quizMatch = quizMatch else {
            print("Quizmatch was nil")
            return
        }
        guard let challenger = quizMatch.challenger, let challenged = quizMatch.challenged else {
            print("challenger, challenged was nil")
            return
        }

        if ParseDbManager.shared.currentQuizzer()!.objectId == challenger.objectId {

            // Quizmatch is over
            quizMatch.turn = nil
            quizMatch.finished = NSNumber(booleanLiteral: true)
            quizMatch.challengerCorrectAnswers = NSNumber(integerLiteral: correctAnswers)
        } else if ParseDbManager.shared.currentQuizzer()!.objectId == challenged.objectId {

            // Pass over quizmatch to challenger
            quizMatch.turn = challenger
            quizMatch.challengedCorrectAnswers = NSNumber(integerLiteral: correctAnswers)
        }
        if appIsTerminating {
            ParseDbManager.shared.mainQueueSaveQuizMatch(quizMatch: quizMatch)
        } else {
            ParseDbManager.shared.bgSaveQuizMatch(quizMatch: quizMatch, completion: completion)
        }


    }

    func computeResultFrom(quizMatch: QuizMatch) -> QuizFinishedResult {
        let challengerName = quizMatch.challenger?.username
        let challengedName = quizMatch.challenged?.username

        let challengerCorrectGuesses = String(quizMatch.challengerCorrectAnswers!.int8Value)
        let challengerIncorrectGuesses: Int = Int(quizMatch.questionCount!.int8Value - quizMatch.challengerCorrectAnswers!.int8Value)

        let challengedCorrectGuesses = String(quizMatch.challengedCorrectAnswers!.int8Value)
        let challengedIncorrectGuesses: Int = Int(quizMatch.questionCount!.int8Value - quizMatch.challengedCorrectAnswers!.int8Value)

        var winner: String?
        if challengerCorrectGuesses > challengedCorrectGuesses {
            winner = challengerName
        } else if challengerCorrectGuesses < challengedCorrectGuesses {
            winner = challengedName
        } else {
            winner = "it´s a tie"
        }

        return QuizFinishedResult(challengerName: challengerName,
                challengedName: challengedName,
                challengerCorrectGuesses: challengerCorrectGuesses,
                challengerIncorrectGuesses: String(challengerIncorrectGuesses),
                challengedCorrectGuesses: challengedCorrectGuesses,
                challengedIncorrectGuesses: String(challengedIncorrectGuesses),
                winner: winner)
    }

    func findFinishedMatcesFor(quizzer: Quizzer, completion: @escaping ([QuizMatch]?, Error?) -> Void) {
        ParseDbManager.shared.bgFindFinishedMatchesFor(quizzer: quizzer, completion: completion)
    }


    func quizFinished(quizMatch: QuizMatch) -> Bool {
        let currentQuizzer = ParseDbManager.shared.currentQuizzer()!
        if let challengerUsername = quizMatch.challenger?.username {
            return challengerUsername == currentQuizzer.username
        }
        return false
    }

    func findFinishedMatchesFor(quizzer: Quizzer, completion: ([QuizMatch]?, Error?) -> Void) {

    }


}


//MARK: Private Methods

extension GameEngine {

    fileprivate func getRandomizedQuestions(maxCount: Int, allQuestions: [PQuizQuestion]) -> [PQuizQuestion] {
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
