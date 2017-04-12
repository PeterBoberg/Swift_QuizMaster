//
// Created by Kung Peter on 2017-04-09.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Alamofire

class QuestionGenerator {

    public func generateQuestions(category: Category,
                                  difficulty: Difficulty,
                                  completionHandler: @escaping ([QuizQuestion]?, QuizError?) -> Void) {


        guard let url = buildUrl(catgory: category, difficulty: difficulty) else {
            print("Invalid Irl")
            completionHandler(nil, QuizError.UrlError("Invalid url"))
            return
        }

        Alamofire.request(url).responseJSON(completionHandler: {

            dataResponse in

            guard  dataResponse.error == nil else {
                print("There was an error running this request")
                completionHandler(nil, QuizError.NetworkError("There was an error in the network request"))
                return
            }

            guard let questionArray = self.buildQuestions(dataResponse.result.value) else {
                print("Could not build questions")
                completionHandler(nil, QuizError.ParseError("Could not build questions"))
                return
            }

            completionHandler(questionArray, nil)
        })

    }


    fileprivate func buildQuestions(_ downloadedData: Any?) -> [QuizQuestion]? {

        guard let jsonData = downloadedData as? Dictionary<String, AnyObject> else {
            return nil
        }

        guard let questionArrayJson = jsonData["results"] as? Array<Dictionary<String, AnyObject>> else {
            return nil
        }

        var questionArray = [QuizQuestion]()

        for questionDict in questionArrayJson {
            let category = questionDict["category"] as? String
            let difficulty = questionDict["difficulty"] as? String
            let question = questionDict["question"] as? String
            let correctAnswer = questionDict["correct_answer"] as? String
            let incorrectAnswers = questionDict["incorrect_answers"] as? [String]

            var cleanedQuestion: String? = nil
            do {
                if var question = question {
                    cleanedQuestion = try question.convertHtmlSymbols()!
                }
            } catch var error {
                print(error)
                continue
            }
            let quizQuestion = QuizQuestion(category: category, difficulty: difficulty, question: cleanedQuestion, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
            questionArray.append(quizQuestion)
        }

        return questionArray

    }

    fileprivate func buildUrl(catgory: Category, difficulty: Difficulty) -> URL? {

        var components = URLComponents()
        components.scheme = Constants.URL.Scheme
        components.host = Constants.URL.Host
        components.path = Constants.URL.Path

        var queryItems: [URLQueryItem] = []

        var categoryString = ""
        switch catgory {

        case Category.history:
            categoryString = Constants.QParamValues.Categories.History
            break
        case Category.mythology:
            categoryString = Constants.QParamValues.Categories.Mythology
            break
        case Category.geography:
            categoryString = Constants.QParamValues.Categories.Geography
            break
        case Category.scienceNature:
            categoryString = Constants.QParamValues.Categories.ScienceNature
            break
        default:
            break
        }
        queryItems.append(URLQueryItem(name: Constants.QParamsKeys.Amount, value: "10"))
        queryItems.append(URLQueryItem(name: Constants.QParamsKeys.Category, value: categoryString))
        queryItems.append(URLQueryItem(name: Constants.QParamsKeys.Difficulty, value: (difficulty.rawValue as! String).lowercased()))

        components.queryItems = queryItems

        return components.url
    }

}





