//
// Created by Kung Peter on 2017-04-23.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Parse

class QuizRound: PFObject, PFSubclassing {

    let correctAnswers: NSNumber
    let incorrectAnswers: NSNumber
    let totalQuestions: NSNumber
    let quizLocation: PFGeoPoint?
    let quizzer: Quizzer

    init(quizzer: Quizzer,
         correctAnswers: NSNumber,
         incorrectAnswers: NSNumber,
         totalQuestions: NSNumber,
         quizLocation: PFGeoPoint?) {

        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.totalQuestions = totalQuestions
        self.quizLocation = quizLocation
        self.quizzer = quizzer
        super.init()
    }

    class func parseClassName() -> String {
        return "QuizRound"
    }

}
