//
// Created by Kung Peter on 2017-04-08.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation

struct Constants {

    struct URL {
        static let BaseUrl = "https://opentdb.com/api.php"

        static let Scheme = "https"
        static let Host = "opentdb.com"
        static let Path = "/api.php"
    }

    struct QParamsKeys {
        static let Amount = "amount"
        static let Category = "category"
        static let Difficulty = "difficulty"
        static let AnswerType = "type"
    }


    struct QParamValues {

        struct Categories {
            static let Mythology = "20"
            static let Geography = "22"
            static let ScienceNature = "17"
            static let History = "23"
        }

        struct Difficulty {
            static let Easy = "easy"
            static let Medium = "medium"
            static let Hard = "hard"
        }

        struct AnswerType {
            static let Multiple = "multiple"
            static let TrueFalse = "boolean"
        }

    }

}


