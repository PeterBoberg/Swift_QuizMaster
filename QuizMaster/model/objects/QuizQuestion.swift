//
// Created by Kung Peter on 2017-04-09.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Parse

struct QuizQuestion {

    let category: String?
    let difficulty: String?
    let question: String?
    let correctAnswer: String?
    let incorrectAnswers: [String]?

    init(category: String?,
         difficulty: String?,
         question: String?,
         correctAnswer: String?,
         incorrectAnswers: [String]?) {

        self.category = category
        self.difficulty = difficulty
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
    }

}
