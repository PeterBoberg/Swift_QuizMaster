//
// Created by Kung Peter on 2017-04-27.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Parse
class QuizMatch: PFObject, PFSubclassing {

    @NSManaged var challenger: Quizzer?
    @NSManaged var challenged: Quizzer?
    @NSManaged var category: String?
    @NSManaged var turn: Quizzer?
    @NSManaged var finished: NSNumber?
    @NSManaged var questionCount: NSNumber?
    @NSManaged var challengerCorrectAnswers: NSNumber?
    @NSManaged var challengedCorrectAnswers: NSNumber?
    @NSManaged var winner: Quizzer?
    @NSManaged var questions: [PQuizQuestion]?

    class func parseClassName() -> String {
        return "QuizMatch"
    }

}
