//
// Created by Kung Peter on 2017-04-27.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Parse

class PQuizQuestion: PFObject, PFSubclassing {

    @NSManaged var category: String?
    @NSManaged var difficulty: String?
    @NSManaged var type: String?
    @NSManaged var question: String?
    @NSManaged var correctAnswer: String?
    @NSManaged var incorrectAnswers: [String]?

    static func parseClassName() -> String {
        return "QuizQuestion"
    }
}
