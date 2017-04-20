//
//  QuizGameResult+CoreDataClass.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-19.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreData

@objc(QuizGameResult)
public class QuizGameResult: NSManagedObject, Comparable {

    public static func <(lhs: QuizGameResult, rhs: QuizGameResult) -> Bool {
        return lhs.correctAnswers < rhs.correctAnswers
    }

    public static func <=(lhs: QuizGameResult, rhs: QuizGameResult) -> Bool {
        return lhs.correctAnswers <= rhs.correctAnswers
    }

    public static func >=(lhs: QuizGameResult, rhs: QuizGameResult) -> Bool {
        return lhs.correctAnswers >= rhs.correctAnswers
    }

    public static func >(lhs: QuizGameResult, rhs: QuizGameResult) -> Bool {
        return lhs.correctAnswers > rhs.correctAnswers
    }

}
