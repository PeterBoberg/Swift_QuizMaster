//
// Created by Kung Peter on 2017-04-09.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation

enum QuizError: Error {

    case NetworkError(String)
    case ParseError(String)
    case UrlError(String)

}