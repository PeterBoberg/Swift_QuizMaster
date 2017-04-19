//
//  QuizGameResult+CoreDataProperties.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-19.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreData


extension QuizGameResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizGameResult> {
        return NSFetchRequest<QuizGameResult>(entityName: "QuizGameResult")
    }

    @NSManaged public var correctAnswers: Int16
    @NSManaged public var incorrectAnswers: Int16
    @NSManaged public var quiestionsInRound: Int16
    @NSManaged public var category: String?
    @NSManaged public var quizPlayer: QuizPlayer?

}
