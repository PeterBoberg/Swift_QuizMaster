//
//  QuizPlayer+CoreDataProperties.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-19.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreData


extension QuizPlayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizPlayer> {
        return NSFetchRequest<QuizPlayer>(entityName: "QuizPlayer")
    }

    @NSManaged public var name: String
    @NSManaged public var avatar: NSData?
    @NSManaged public var quizGameResult: NSSet?


}

// MARK: Generated accessors for quizGameResult
extension QuizPlayer {

    @objc(addQuizGameResultObject:)
    @NSManaged public func addToQuizGameResult(_ value: QuizGameResult)

    @objc(removeQuizGameResultObject:)
    @NSManaged public func removeFromQuizGameResult(_ value: QuizGameResult)

    @objc(addQuizGameResult:)
    @NSManaged public func addToQuizGameResult(_ values: NSSet)

    @objc(removeQuizGameResult:)
    @NSManaged public func removeFromQuizGameResult(_ values: NSSet)

}
