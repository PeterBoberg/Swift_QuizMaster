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

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var avatar: NSData?
    @NSManaged public var quizGameResult: NSSet?

}

// MARK: Generated accessors for quixGameResult
extension QuizPlayer {

    @objc(addQuixGameResultObject:)
    @NSManaged public func addToQuizGameResult(_ value: QuizGameResult)

    @objc(removeQuixGameResultObject:)
    @NSManaged public func removeFromQuizGameResult(_ value: QuizGameResult)

    @objc(addQuixGameResult:)
    @NSManaged public func addToQuizGameResult(_ values: NSSet)

    @objc(removeQuixGameResult:)
    @NSManaged public func removeFromQuizGameResult(_ values: NSSet)

}
