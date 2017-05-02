//
// Created by Kung Peter on 2017-04-23.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ParseDbManager {

    static let shared = ParseDbManager()

    private init() {
    }

    func bgRegisterNewQuizzer(username: String,
                              email: String,
                              password: String,
                              image: UIImage,
                              completion: ((Bool, NSError?) -> Void)?) {


        let newQuizzer = Quizzer()
        newQuizzer.username = username
        newQuizzer.email = email
        newQuizzer.password = password
        newQuizzer.avatarImage = PFFile(name: "\(username)_avatarImg.jpg", data: UIImageJPEGRepresentation(image, 1.0)!)
        newQuizzer.friends = [Quizzer]()


        newQuizzer.signUpInBackground(block: {
            (sucess, error) in

            guard error == nil else {
                completion?(false, error as! NSError)
                return
            }
            completion?(true, nil)
        })

    }

    func bgLoginQuizzer(username: String, password: String, completion: ((Quizzer?, Error?) -> Void)?) {

        PFUser.logInWithUsername(inBackground: username, password: password, block: {
            (pfUser, error) in
            print("inside compl handl")
            guard  error == nil else {
                completion?(nil, error)
                return
            }
            completion?(pfUser as! Quizzer, error)
        })
    }

    func bgUpdateQuizzer(quizzer: Quizzer, completion: ((Bool, Error?) -> Void)?) {
        quizzer.saveInBackground(block: {
            (bool, error) in
            completion?(bool, error)
        })

    }


    func bgFindQuizzers(containing stringPart: String, completion: (([Quizzer]?, Error?) -> Void)?) {

        let query = PFUser.query()!
        query.whereKey("username", contains: stringPart)
        query.findObjectsInBackground(block: {
            (users, error) in

            guard error == nil else {
                print(error)
                completion?(nil, error)
                return
            }

            if let users = users as? [Quizzer] {
                completion?(users, nil)
            } else {
                // TODO implement bettter error handling in findUsers
                print("Could not cast to quizzers")
            }

        })
    }


    func bgFindFriendsOf(quizzer: Quizzer, completion: (([Quizzer]?, Error?) -> Void)?) {


        var friendIds = [String]()
        for friend in quizzer.friends! {
            friendIds.append(friend.objectId!)
        }

        let query = PFUser.query()!
        query.whereKey("objectId", containedIn: friendIds)
        query.findObjectsInBackground(block: {
            (friends, error) in

            completion?(friends as? [Quizzer], error)
        })

    }

    func bgDeleteFriendOfQuizzer(quizzer: Quizzer, friend: Quizzer, completion: ((Bool, Error?) -> Void)?) {

        if alreadyFriends(firstQuizzer: quizzer, secondQuizzer: friend) {
            var friends = quizzer.friends!
            print(friends)
            for i in 0..<friends.count {
                if friends[i].objectId == friend.objectId {
                    friends.remove(at: i)
                    break
                }
            }

            quizzer.friends = friends
            quizzer.saveInBackground(block: {
                (bool, error) in
                completion?(bool, error)
            })
        }
    }

    func bgDownloadAvatarPictureFor(quizzer: Quizzer, completion: ((UIImage?, Error?) -> Void)?) {
        if let imageFile = quizzer.avatarImage {
            imageFile.getDataInBackground({
                (data, error) in

                guard error == nil else {
                    completion?(nil, error)
                    return
                }

                if let data = data {
                    let image = UIImage(data: data)
                    completion?(image, nil)
                } else {
                    // TODO implement better error handling here
                    completion?(nil, nil)
                }
            })
        }
    }

    func alreadyFriends(firstQuizzer: Quizzer, secondQuizzer: Quizzer) -> Bool {

        if firstQuizzer.objectId == secondQuizzer.objectId {
            return true
        }

        if let quizzerFriends = firstQuizzer.friends {
            for friend in quizzerFriends {
                if friend.objectId == secondQuizzer.objectId {
                    return true
                }
            }
            return false
        }
        return false
    }

    func beSendQuizChallengeBetween(challenger: Quizzer,
                                    challenged: Quizzer,
                                    catgory: Category,
                                    completion: ((Bool, Error?) -> Void)?) {

        let quizChallenge = QuizChallange()
        quizChallenge.challenger = challenger
        quizChallenge.challenged = challenged
        quizChallenge.category = catgory.rawValue

        quizChallenge.saveInBackground(block: {
            (bool, error) in
            completion?(bool, error)
        })
    }


    func bgFindIncomingRequestsFor(quizzer: Quizzer, completion: (([QuizChallange]?, Error?) -> Void)?) {

        let firstQuery = QuizChallange.query()!
        firstQuery.whereKey("challenged", equalTo: quizzer)
        let secondQuery = QuizChallange.query()!
        secondQuery.whereKey("challenger", equalTo: quizzer)
        let query = PFQuery.orQuery(withSubqueries: [firstQuery, secondQuery])
        query.includeKey("challenged")
        query.includeKey("challenger")
        query.findObjectsInBackground(block: {
            (challenges, error) in

            guard error == nil else {
                completion?(nil, error)
                return
            }

            if let challenges = challenges as? [QuizChallange] {
                completion?(challenges, nil)
            } else {
                print("Could not cast to [QuizChallenge]")
            }
        })

    }


    func bgFindMatchesFor(quizzer: Quizzer, completion: (([QuizMatch]?, Error?) -> Void)?) {

        let firstQuery = QuizMatch.query()!
        firstQuery.whereKey("challenger", equalTo: quizzer)
        firstQuery.whereKey("finished", notEqualTo: NSNumber(booleanLiteral: true))


        let secondQuery = QuizMatch.query()!
        secondQuery.whereKey("challenged", equalTo: quizzer)
        secondQuery.whereKey("finished", notEqualTo: NSNumber(booleanLiteral: true))

        let mainQuery = PFQuery.orQuery(withSubqueries: [firstQuery, secondQuery])
        mainQuery.includeKey("challenger")
        mainQuery.includeKey("challenged")
        mainQuery.includeKey("turn")

        mainQuery.findObjectsInBackground(block: {
            (matches, error) in

            guard error == nil else {
                completion?(nil, error)
                return
            }
            if let matches = matches as? [QuizMatch] {
                completion?(matches, nil)
            } else {
                // TODO better error handling
                completion?(nil, NSError())
            }
        })
    }

    func bgCheckPendingMatches(firstQuizzer: Quizzer,
                               secondQuizzer: Quizzer,
                               completion: @escaping ((Bool, Error?) -> Void)) {
        let challerngerRequestQuery = QuizChallange.query()!
        challerngerRequestQuery.whereKey("challenger", equalTo: firstQuizzer)
        challerngerRequestQuery.whereKey("challenged", equalTo: secondQuizzer)

        let challangedRequestQuery = QuizChallange.query()!
        challangedRequestQuery.whereKey("challenger", equalTo: secondQuizzer)
        challangedRequestQuery.whereKey("challenged", equalTo: firstQuizzer)

        let challangeQuery = PFQuery.orQuery(withSubqueries: [challerngerRequestQuery, challangedRequestQuery])
        challangeQuery.findObjectsInBackground(block: {
            (challenges: [PFObject]?, error: Error?) in

            guard error == nil else {
                completion(false, error)
                return
            }

            if let challenges = challenges as? [QuizChallange] {

                guard challenges.count == 0 else {
                    completion(true, nil)
                    return
                }
                let quizMatchChallegerQuery = QuizMatch.query()!
                quizMatchChallegerQuery.whereKey("challenger", equalTo: firstQuizzer)
                quizMatchChallegerQuery.whereKey("challenged", equalTo: secondQuizzer)

                let quizMatchChallangedQuery = QuizMatch.query()!
                quizMatchChallangedQuery.whereKey("challenger", equalTo: secondQuizzer)
                quizMatchChallangedQuery.whereKey("challenged", equalTo: firstQuizzer)

                let quizMatchQuery = PFQuery.orQuery(withSubqueries: [quizMatchChallegerQuery, quizMatchChallangedQuery])
                quizMatchQuery.findObjectsInBackground(block: {
                    (quizMatches: [PFObject]?, error: Error?) in

                    guard error == nil else {
                        completion(false, error)
                        return
                    }

                    if let quizMatches = quizMatches as? [QuizMatch] {
                        guard quizMatches.count == 0 else {
                            completion(true, nil)
                            return
                        }

                        completion(false, nil)

                    } else {
                        print("could not cast to [QuizMatch]")
                    }
                })


            } else {
                print("Could not cast to [QuizChallege]")
            }

        })


    }

    func deleteQuizChallege(_ challenge: QuizChallange, completion: ((Bool, Error?) -> Void)?) {
        challenge.deleteInBackground(block: completion)
    }


    func getAllQuestionsFor(category: String, completion: @escaping ([PQuizQuestion]?, Error?) -> Void) {

        let query = PQuizQuestion.query()!
        query.whereKey("category", equalTo: category)
        query.findObjectsInBackground(block: {
            (questions, error) in
            completion(questions as? [PQuizQuestion], error)
        })

    }

    func createNewQuizMatch(challenger: Quizzer,
                            challenged: Quizzer,
                            questions: [PQuizQuestion],
                            category: String,
                            completion: @escaping (Bool, Error?) -> Void) {

        let quizMatch = QuizMatch()
        quizMatch.challenger = challenger
        quizMatch.challenged = challenged
        quizMatch.category = category
        quizMatch.turn = challenged
        quizMatch.finished = NSNumber(booleanLiteral: false)
        quizMatch.questionCount = NSNumber(integerLiteral: questions.count)
        quizMatch.challengerCorrectAnswers = NSNumber(integerLiteral: -1)
        quizMatch.challengedCorrectAnswers = NSNumber(integerLiteral: -1)
        quizMatch.questions = questions

        quizMatch.saveInBackground(block: {
            (success, error) in
            completion(success, error)
        })

    }


    func currentQuizzer() -> Quizzer? {
        return PFUser.current() as! Quizzer
    }

    func logOutCurrentQuizzer() {
        PFUser.logOutInBackground()
    }

    func currentQuizzerIsLoggedIn() -> Bool {
        return PFUser.current() != nil
    }


}
