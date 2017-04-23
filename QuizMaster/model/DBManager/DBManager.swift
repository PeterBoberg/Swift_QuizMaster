//
// Created by Kung Peter on 2017-04-20.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreData
import Dispatch
import UIKit

class LocalDbManager {

    static let shared: LocalDbManager = LocalDbManager()
    let workerQueue = DispatchQueue.global(qos: .userInitiated)
    let mainQueue = DispatchQueue.main
    var context: NSManagedObjectContext? = nil

    private init() {
        guard  let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        context = delegate.persistentContainer.viewContext
    }

    func getAllQuizPlayers(completion: @escaping ([QuizPlayer]?, Error?) -> Void) {
        guard let context = context else {
            //TODO Implement better error handling in dbmanager
            completion(nil, NSError())
            return
        }

        workerQueue.async(execute: {
            [unowned self] in
            let fetchRequest: NSFetchRequest<QuizPlayer> = QuizPlayer.fetchRequest()
            var quizPlayers: [QuizPlayer]?

            do {
                quizPlayers = try context.fetch(fetchRequest)
            } catch let error {
                self.mainQueue.async(execute: {
                    completion(nil, error)
                })
            }

            self.mainQueue.async(execute: {
                completion(quizPlayers, nil)
            })
        })


    }

    func saveNewQuizPlayer(name: String, avatar: UIImage?, completion: ((Error?) -> Void)?) {

        guard  let context = context else {
            completion?(NSError())
            return
        }

        workerQueue.async(execute: {
            [unowned self] in

            let newPlayer = QuizPlayer(entity: QuizPlayer.entity(), insertInto: context)
            newPlayer.name = name
            if let avatar = avatar {
                newPlayer.avatar = UIImageJPEGRepresentation(avatar, 1.0) as! NSData
            }
            do {
                try context.save()
                self.mainQueue.async(execute: {
                    completion?(nil)
                })
            } catch let error {
                self.mainQueue.async(execute: {
                    completion?(error)
                })
            }
        })
    }

    func updateQuizPlayer(player: QuizPlayer, completion: ((Error?) -> Void)?) {
        guard let context = context else {
            completion?(NSError())
            return
        }
        workerQueue.async(execute: {
            [unowned self] in
            do {
                try context.save()
                self.mainQueue.async(execute: {
                    completion?(nil)
                })
            } catch let error {
                self.mainQueue.async(execute: {
                    completion?(error)
                })
            }
        })
    }

    func deleteQuizPlayer(player: QuizPlayer, completion: ((Error?) -> Void)?) {
        guard let context = context else {
            completion?(NSError())
            return
        }

        workerQueue.async(execute: {
            [unowned self] in
            context.delete(player)

            self.mainQueue.async(execute: {
                completion?(nil)
            })
        })
    }

    func addNewQuizResult(forPlayer player: QuizPlayer,
                          quizRoundResult: QuizRoundResult,
                          completion: ((Error?) -> Void)?) {

        guard let context = context else {
            completion?(NSError())
            return
        }

        workerQueue.async(execute: {
            [unowned self] in
            let quizGameResult = QuizGameResult(entity: QuizGameResult.entity(), insertInto: context)
            quizGameResult.correctAnswers = Int16(quizRoundResult.correctGuesses)!
            quizGameResult.incorrectAnswers = Int16(quizRoundResult.incorrectGuesses)!
            quizGameResult.quiestionsInRound = Int16(quizRoundResult.totalQuestions)!
            quizGameResult.category = quizRoundResult.category
            player.addToQuizGameResult(quizGameResult)

            do {
                try context.save()
                self.mainQueue.async(execute: {
                    completion?(nil)
                })
            } catch let error {
                self.mainQueue.async(execute: {
                    completion?(error)
                })
            }
        })
    }

}
