//
// Created by Kung Peter on 2017-04-27.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Parse
class QuizChallange: PFObject, PFSubclassing {

    @NSManaged var challenger: Quizzer?
    @NSManaged var challenged: Quizzer?
    @NSManaged var accepted: Bool?
    @NSManaged var declined: Bool?
    @NSManaged var turn: Quizzer?
    @NSManaged var category: String?

    class func parseClassName() -> String {
        return "QuizChallenge"
    }

}
