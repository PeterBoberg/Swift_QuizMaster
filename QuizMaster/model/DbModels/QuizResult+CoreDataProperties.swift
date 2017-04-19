//
//  QuizResultProperties.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-19.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreData


extension QuizRoundResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizRoundResult> {
        return NSFetchRequest<QuizRoundResult>(entityName: "QuizResult")
    }

    @NSManaged public var correctAnswers: Int16
    @NSManaged public var datePlayed: NSDate?
    @NSManaged public var incorrectAnswers: Int16
    @NSManaged public var totalAnsweres: Int16
    @NSManaged public var player: Player?

}
