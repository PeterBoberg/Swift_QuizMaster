//
//  PlayerProperties.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-19.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var avatar: NSData?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var quizResults: NSSet?

}

// MARK: Generated accessors for quizResults
extension Player {

    @objc(addQuizResultsObject:)
    @NSManaged public func addToQuizResults(_ value: QuizRoundResult)

    @objc(removeQuizResultsObject:)
    @NSManaged public func removeFromQuizResults(_ value: QuizRoundResult)

    @objc(addQuizResults:)
    @NSManaged public func addToQuizResults(_ values: NSSet)

    @objc(removeQuizResults:)
    @NSManaged public func removeFromQuizResults(_ values: NSSet)

}
