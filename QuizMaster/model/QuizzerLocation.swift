//
// Created by Peter Boberg on 2017-05-12.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Parse
class QuizzerLocation: PFObject, PFSubclassing {

    @NSManaged var quizMatch: QuizMatch?
    @NSManaged var quizzer: Quizzer?
    @NSManaged var location: PFGeoPoint?

    class func parseClassName() -> String {
        return "QuizzerLocation"
    }

}
